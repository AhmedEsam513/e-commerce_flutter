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
final class ProfileError extends ProfileState{
  final String message;
  ProfileError(this.message);
}


// << ProfilePhoto States >>
final class ProfilePhotoLoading extends ProfileState{}
final class ProfilePhotoLoaded extends ProfileState{
  final UserModel userData;
  ProfilePhotoLoaded(this.userData);
}
final class ProfilePhotoError extends ProfileState{
  final String message;
  ProfilePhotoError(this.message);

}


class UserInfoUpdated extends ProfileState{
  String newName;
  UserInfoUpdated(this.newName);
}