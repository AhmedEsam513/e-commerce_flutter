part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}


class FetchProfileEvent extends ProfileEvent {}
class LogOutEvent extends ProfileEvent {}
class DeleteUserEvent extends ProfileEvent {}
class UpdateProfilePhotoEvent extends ProfileEvent {}
class DeleteProfilePhotoEvent extends ProfileEvent {}
class UpdateUserInfoEvent extends ProfileEvent {
  final String newName;
  UpdateUserInfoEvent(this.newName);
}

