part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

// << Sign up and Log in States >>

final class AuthLoading extends AuthState{}

final class AuthLoaded extends AuthState{
  //final UserModel userData;
  //AuthLoaded({required this.userData});
}

final class AuthError extends AuthState{
  final String message;
  AuthError(this.message);

}

//<< NoUserFoundState >> will be emitted in the start of the app if the user
// is not logged in to move him to log in page
final class NoUserFoundState extends AuthState{}

// << Log out State >>

final class LoggingOut extends AuthState{}
final class LoggedOut extends AuthState{}
final class LogOutError extends AuthState{
  final String message;
  LogOutError(this.message);
}

final class ProfileLoading extends AuthState{}
final class ProfileLoaded extends AuthState{
  final UserModel userData;
  ProfileLoaded(this.userData);
}
final class ProfileError extends AuthState{}