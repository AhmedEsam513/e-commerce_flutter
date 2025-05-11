import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/product_details_services.dart';
import 'package:flutter/cupertino.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  final _productDetailsServices = ProductDetailsServicesImpl();
  final _authServices = AuthServicesImpl();

  int quantity = 1;
  ProductSizes? selectedSize;

  void getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {
      final fetchedProduct =
          await _productDetailsServices.fetchProductDetails(id);
      emit(ProductDetailsLoaded(fetchedProduct));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
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

  void addToCart(String id) async {

    //emit() the state of adding the item in the cart
    emit(AddingToCartState());

    try {

      debugPrint("i will fetch the product details");
      //fetch the product details
      final fetchedProduct =
          await _productDetailsServices.fetchProductDetails(id);
      debugPrint("i fetched the product details");
      //instantiating the cartItemModel element
      final newItem = CartItemModel(
        cartItemId: DateTime.now().toIso8601String(),
        product: fetchedProduct,
        quantity: quantity,
        size: selectedSize!,
        total: (fetchedProduct.price) * quantity,
      );

      debugPrint("i will add the item in the cart");
      // add the item in the cart
      await _productDetailsServices.addToCart(
        _authServices.getCurrentUser()!.uid,
        newItem,
      );
      debugPrint("i added the item in the cart");
      //emit() the state that we will receive and use it in the product details page
      emit(AddedToCartState());
      debugPrint("i emitted the state successfully");
    } catch (e) {
      emit(AddToCartErrorState(e.toString()));
    }
  }
}
