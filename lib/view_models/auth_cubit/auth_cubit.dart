import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';
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
        final currentUserId = _authServicesObject.getCurrentUser()!.uid;

        final UserModel currentUserData =
            await _fireStoreServices.getDocument<UserModel>(
          path: ApiPaths.user(currentUserId),
          builder: UserModel.fromMap,
        );

        emit(AuthLoaded(userData: currentUserData));
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

        emit(AuthLoaded(userData: newUser));
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
        emit(AuthLoaded(userData: currentUserData));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    }else
      {emit(NoUserFoundState());}
  }

  void fetchProfile() async {
    emit(ProfileLoading());
    final currentUserId = _authServicesObject.getCurrentUser()!.uid;
    try {
      final currentUserData = await _fireStoreServices.getDocument<UserModel>(
          path: ApiPaths.user(currentUserId), builder: UserModel.fromMap);
      emit(ProfileLoaded(currentUserData));
    } catch (e) {
      emit(ProfileError());
    }
  }

  // << Log Out >>
  void logOut() async {
    emit(LoggingOut());
    try {
      await _authServicesObject.logOut();
      emit(LoggedOut());
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
