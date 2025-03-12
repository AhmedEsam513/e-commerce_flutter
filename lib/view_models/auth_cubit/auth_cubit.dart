import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _authServicesObject = AuthServicesImpl();
  final _fireStoreServices = FireStoreServices.instance;


  // <<  LogIn  >>
  void logIn(String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await _authServicesObject.logIn(email, password);
      if (result) {

        debugPrint("i logged in successfully, and will get the user data");
        final currentUserId = _authServicesObject.getCurrentUser()!.uid;

        final currentUserData = await _fireStoreServices.getDocument<UserModel>(
            path: ApiPaths.user(currentUserId), builder: UserModel.fromMap);
        debugPrint("i got the user data, and will emit AuthLoaded");

        emit(AuthLoaded(userData: currentUserData));
        debugPrint("i emitted AuthLoaded");
      } else {
        emit(AuthError("Invalid email or password"));
      }
    } catch (e) {
      debugPrint(e.toString());
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

        emit(AuthLoaded(userData: newUser));
      } else {
        emit(AuthError("Invalid email or password"));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(AuthError(e.toString()));
    }
  }

  // << Get User >>
  void getUser() async {

    //emit(AuthLoading());
    final result = _authServicesObject.getCurrentUser();
    if (result != null) {
      try {
        final currentUserData = await _fireStoreServices.getDocument<UserModel>(
            path: ApiPaths.user(result.uid), builder: UserModel.fromMap);
        emit(AuthLoaded(userData: currentUserData));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    }
  }

  // << Log Out >>
  void logOut() async {
    debugPrint("i will log out");
    emit(LoggingOut());
    try {
      await _authServicesObject.logOut();
      debugPrint("i logged out successfully");
      emit(LoggedOut());
      debugPrint("i emitted LoggedOut");
      //emit(AuthLoading());
    } catch (e) {
      emit(LogOutError());
    }
  }

  // << Delete User >>
  void deleteUser() async {
    emit(LoggingOut());

    try {
      await _authServicesObject.deleteUser();
      emit(LoggedOut());
    } catch (e) {
      emit(LogOutError());
    }
  }
}
