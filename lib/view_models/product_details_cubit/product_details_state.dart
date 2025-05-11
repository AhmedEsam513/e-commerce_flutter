part of 'product_details_cubit.dart';

sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}


class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  ProductItemModel product;

  ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final String error;

  ProductDetailsError(this.error);
}


// Quantity State
class QuantityChangedState extends ProductDetailsState {
  final int newQuantity;

  QuantityChangedState({required this.newQuantity});
}

// Size State
class SizeSelectedState extends ProductDetailsState {
  ProductSizes selectedSize;

  SizeSelectedState({required this.selectedSize});
}


// Add To Cart States
class AddingToCartState extends ProductDetailsState {}

class AddedToCartState extends ProductDetailsState {}

class AddToCartErrorState extends ProductDetailsState {
  final String message;

  AddToCartErrorState(this.message);
}
