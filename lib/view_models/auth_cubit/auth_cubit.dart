import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/services/hive_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _authServicesObject = AuthServicesImpl();
  final _fireStoreServices = FireStoreServices.instance;
  final _hiveServices = HiveServices();

  // <<  LogIn  >>
  void logIn(String email, String password) async {
    emit(AuthLoading());

    try {
      debugPrint("i will log in ");

      // Log in the user
      final result = await _authServicesObject.logIn(email, password);

      // Check if the log in was successful
      if (result) {
        debugPrint("i logged in ");

        // Get the current user's ID
        final currentUserId = _authServicesObject.getCurrentUser()!.uid;

        // Get the current user's data (from the FireStore)
        final UserModel currentUserData =
            await _fireStoreServices.getDocument<UserModel>(
          path: ApiPaths.user(currentUserId),
          builder: UserModel.fromMap,
        );
        debugPrint("current user data :${currentUserData.favorites}");

        // Get the current user's favorite products (FireStore & Hive)
        for (var productId in currentUserData.favorites!) {

          // Fetch each product from FireStore
          final fetchedProduct =
              await _fireStoreServices.getDocument<ProductItemModel>(
                  path: ApiPaths.product(productId),
                  builder: ProductItemModel.fromMap);

          // Add each product to the Hive favorites box
          _hiveServices.addFavorite(fetchedProduct);
        }

        // Emit the AuthLoaded state with the current user's data
        emit(AuthLoaded());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // << SignUp>>
  void signUp(
      String firstName, String lastName, String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await _authServicesObject.signUp(email, password);
      if (result) {
        final currentUserId = _authServicesObject.getCurrentUser()!.uid;

        final newUser = UserModel(
          userID: currentUserId,
          firstName: firstName,
          lastName: lastName,
          email: email,
          createdAt: DateTime.now().toIso8601String(),
        );

        await _fireStoreServices.setData(
            newUser.toMap(), ApiPaths.user(newUser.userID));

        emit(AuthLoaded());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(AuthError(e.toString()));
    }
  }

  // << Get User >>
  void getUser() async {
    emit(AuthLoading());
    final result = _authServicesObject.getCurrentUser();
    if (result != null) {
      try {
        final currentUserData = await _fireStoreServices.getDocument<UserModel>(
            path: ApiPaths.user(result.uid), builder: UserModel.fromMap);
        emit(AuthLoaded());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    } else {
      emit(NoUserFoundState());
    }
  }

}
