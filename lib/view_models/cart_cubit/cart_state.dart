part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  List<CartItemModel> cartList;
  double totalAmount;

  CartLoaded({required this.cartList,required this.totalAmount});
}
final class CartEmptyState extends CartState {}

final class CartError extends CartState {
  String errorMessage;

  CartError(this.errorMessage);
}

class CartItemLoaded extends CartState {
  int productIndex;

  CartItemLoaded(this.productIndex);
}

class quantityChangedState extends CartState {
  int itemIndex;
  int newQuantity;
  double newTotal;

  quantityChangedState(this.itemIndex,this.newQuantity,this.newTotal);
}
