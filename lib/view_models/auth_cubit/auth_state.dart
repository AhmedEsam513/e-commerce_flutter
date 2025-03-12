part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

// << Sign up and Log in States >>

final class AuthLoading extends AuthState{}

final class AuthLoaded extends AuthState{
  final UserModel userData;
  AuthLoaded({required this.userData});
}

final class AuthError extends AuthState{
  final String message;
  AuthError(this.message);

}

// << Log out State >>

final class LoggingOut extends AuthState{}
final class LoggedOut extends AuthState{}
final class LogOutError extends AuthState{}