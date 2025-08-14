part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {}

class LogOutEvent extends ProfileEvent {}

class DeleteUserEvent extends ProfileEvent {}

class UpdateProfilePhotoEvent extends ProfileEvent {}

class DeleteProfilePhotoEvent extends ProfileEvent {}

class ChangeUserInfoEvent extends ProfileEvent {
  final String oldFirstName;
  final String newFirstName;
  final String oldLastName;
  final String newLastName;

  ChangeUserInfoEvent(
    this.oldFirstName,
    this.newFirstName,
    this.oldLastName,
    this.newLastName,
  );
}

class ReturnUserInfoToOriginalEvent extends ProfileEvent {
  ReturnUserInfoToOriginalEvent();
}


class UpdateUserInfoEvent extends ProfileEvent{
  final String newFirstName;
  final String newLastName;

  UpdateUserInfoEvent({required this.newFirstName, required this.newLastName});
}