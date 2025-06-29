part of 'profile_bloc.dart';

class ProfileState {}

final class ProfileInitial extends ProfileState {}

// << Log out States >>
final class LoggingOut extends ProfileState{}
final class LoggedOut extends ProfileState{}
final class LogOutError extends ProfileState{
  final String message;
  LogOutError(this.message);
}


// << Profile States >>
final class ProfileLoading extends ProfileState{}
final class ProfileLoaded extends ProfileState{
  final UserModel userData;
  ProfileLoaded(this.userData);
}
final class ProfileError extends ProfileState{}