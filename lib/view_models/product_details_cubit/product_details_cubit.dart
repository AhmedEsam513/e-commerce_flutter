import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:flutter/cupertino.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  int quantity = 1;
  ProductSizes? selectedSize;

  void getProductDetails(int productIndex) async {
    //emit(ProductDetailsLoading());
    //await Future.delayed(Duration(seconds: 1));
    emit(ProductDetailsLoaded(products[productIndex]));
  }

  void incrementQuantity(int notUsed) {
    quantity++;
    emit(QuantityChangedState(newQuantity: quantity));
  }

  void decrementQuantity(int notUsed) {
    quantity--;
    emit(QuantityChangedState(newQuantity: quantity));
  }

  void selectSize(ProductSizes size) {
    selectedSize = size;
    emit(SizeSelectedState(selectedSize: size));
  }

  void addToCart(int productIndex) async {
    //instanciating the cartItemModel element
    final newItem = CartItemModel(
      productId: productIndex,
      item: products[productIndex],
      quantity: quantity,
      size: selectedSize!,
      total: products[productIndex].price * quantity,
    );

    // add the item in the cart
    cart.add(newItem);

    //emit() the state of adding the item in the cart
    emit(AddingToCartState());

    //Delayed
    await Future.delayed(Duration(seconds: 1));

    //emit() the state that we will recieve and check on in the product details page
    emit(AddedToCartState(newItem));

    debugPrint("Cart after adding item: $cart");
  }
}
