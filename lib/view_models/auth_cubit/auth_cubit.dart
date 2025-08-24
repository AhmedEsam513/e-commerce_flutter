import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/services/hive_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _authServicesObject = AuthServicesImpl();
  final _fireStoreServices = FireStoreServices.instance;
  final _hiveServices = HiveServices();

  String get currentUserId => _authServicesObject.getCurrentUser()!.uid;

  // Flag will be true if the "I have verified" button is pressed
  bool isEmailVerified = false;

  /// Log In
  void logIn(String email, String password) async {
    emit(LoggingIn());

    try {
      // Log in the user
      final result = await _authServicesObject.logIn(email, password);

      // Check if the log in was successful
      if (result) {
        // Check if the user verified his email
        if (!_authServicesObject.getCurrentUser()!.emailVerified) {
          _authServicesObject.sendEmailVerification();
          emit(AuthNeedVerify());
        } else {
          // Get the current user's data (from the FireStore)
          final UserModel currentUserData =
              await _fireStoreServices.getDocument<UserModel>(
            path: ApiPaths.user(currentUserId),
            builder: UserModel.fromMap,
          );

          // Get the current user's favorite products (FireStore & Hive)
          fetchFavoritesAndSaveToHive(currentUserData);

          // Emit the AuthLoaded state with the current user's data
          emit(LoggedIn());
        }
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  /// Fetch favorites from Firestore and save them to Hive
  void fetchFavoritesAndSaveToHive(UserModel user) async {
    for (var productId in user.favorites!) {
      // Fetch each product from FireStore
      final fetchedProduct =
          await _fireStoreServices.getDocument<ProductItemModel>(
              path: ApiPaths.product(productId),
              builder: ProductItemModel.fromMap);

      // Add each product to the Hive favorites box
      _hiveServices.addFavorite(fetchedProduct);
    }
  }

  /// Check Email Verification
  void checkEmailVerification() async {
    emit(EmailVerifying());
    try {
      final isVerified = await _authServicesObject.isEmailVerified();

      if (isVerified) {
        _fireStoreServices.updateData(
          {"isEmailVerified": true},
          ApiPaths.user(currentUserId),
        );

        isEmailVerified = true;

        emit(EmailVerified());
      } else {
        emit(
          EmailVerificationError(
              "Email not verified. Please check your inbox or spam folder and try again."),
        );
      }
    } catch (e) {
      emit(EmailVerificationError(e.toString()));
    }
  }

  /// Sign Up
  void signUp(
      String firstName, String lastName, String email, String password) async {
    emit(SigningUp());

    try {
      final result = await _authServicesObject.signUp(email, password);
      if (result) {
        await _authServicesObject.sendEmailVerification();
        isEmailVerified = false;

        final newUser = UserModel(
          userID: currentUserId,
          firstName: firstName,
          lastName: lastName,
          email: email,
          createdAt: DateTime.now().toIso8601String(),
        );

        await _fireStoreServices.setData(
            newUser.toMap(), ApiPaths.user(newUser.userID));

        emit(SignedUp());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(SignUpError(
            "This email already in use, Log in and Verify if not verified"));
      }
    }
  }

  /// Get User
  void checkAuthStatus() async {
    emit(CheckingAuthStatus());
    try {
      final result = _authServicesObject.getCurrentUser();

      // Check if the user is logged-in
      if (result != null) {
        // Check if the logged-in user verified his e-mail
        final isVerified = await _authServicesObject.isEmailVerified();

        // Check if the user verified the email but did not press "I have verified" button and he re-opened the app
        // to update the firestore
        if (isVerified && !isEmailVerified) {
          await _fireStoreServices.updateData(
            {"isEmailVerified": true},
            ApiPaths.user(currentUserId),
          );
          isEmailVerified = true;
        }

        if (isVerified) {
          emit(AuthenticatedUser());
        } else {
          emit(UnverifiedUser());
        }
      } else {
        emit(UnauthenticatedUser());
      }
    } catch (e) {
      emit(CheckingAuthStatusError(e.toString()));
    }
  }
}
