part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}


class FetchProfileEvent extends ProfileEvent {}
class LogOutEvent extends ProfileEvent {}
class DeleteUserEvent extends ProfileEvent {}
