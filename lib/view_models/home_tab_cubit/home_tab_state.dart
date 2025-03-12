part of 'home_tab_cubit.dart';

sealed class HomeTabState {}

final class HomeTabInitial extends HomeTabState {}

class HomeTabLoading extends HomeTabState {}

class HomeTabLoaded extends HomeTabState {
  final List<ProductItemModel> products;
  final List<Widget> banners;
  final UserModel user;

  HomeTabLoaded({
    required this.products,
    required this.banners,
    required this.user,
  });
}

class HomeTabError extends HomeTabState {
  final String message;

  HomeTabError(this.message);
}
