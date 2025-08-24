part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

// Login States
class LoggingIn extends AuthState {}

class LoggedIn extends AuthState {}

class LoginError extends AuthState {
  final String message;

  const LoginError(this.message);
}

// SignUp States
class SigningUp extends AuthState {}

class SignedUp extends AuthState {}

class SignUpError extends AuthState {
  final String message;

  const SignUpError(this.message);
}

// Email Verification States
class EmailVerifying extends AuthState {}

class EmailVerified extends AuthState {}

class EmailVerificationError extends AuthState {
  final String message;

  const EmailVerificationError(this.message);
}

class AuthNeedVerify extends AuthState {}



//<< NoUserFoundState >> will be emitted in the start of the app if the user
// is not logged in to move him to log in page
//final class NoUserFoundState extends AuthState {}

//final class NoVerifiedUserFoundState extends AuthState {}

// App Startup States
class CheckingAuthStatus extends AuthState {}

    // Authenticated User = there is logged-in and verified account --> go to Home
class AuthenticatedUser extends AuthState {}
    // Unauthenticated User = there is no logged-in account --> go to Login
class UnauthenticatedUser extends AuthState {}
    // Unverified User = there is logged-in account but not verified --> go to verification
class UnverifiedUser extends AuthState {}

class CheckingAuthStatusError extends AuthState {
  final String message;
  const CheckingAuthStatusError(this.message);
}


