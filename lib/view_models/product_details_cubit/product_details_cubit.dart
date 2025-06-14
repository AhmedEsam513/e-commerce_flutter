import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/hive_services.dart';
import 'package:e_commerce/services/product_details_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  final _productDetailsServices = ProductDetailsServicesImpl();
  final _authServices = AuthServicesImpl();
  final _hiveServices = HiveServices();

  int quantity = 1;
  ProductSizes? selectedSize;

  void getProductDetails(String id) async {
    emit(ProductDetailsLoading());
    try {

      // Check if the product is a favorite (using Hive)
      final isFavorite =_hiveServices.getFavoritesIDs().contains(id);

      // Emit the loaded state with the fetched product and favorite status
      emit(ProductDetailsLoaded(isFavorite));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  void favorite(ProductItemModel product) async {
    try {
      debugPrint("i will add to hive");
      await _hiveServices.addFavorite(product);
      debugPrint("i added to hive and will emit added state");
      emit(FavoriteAdded());

      debugPrint("i emitted added state");
      debugPrint("fav length : ${_hiveServices.getFavoritesIDs().length}");
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  void unFavorite(ProductItemModel product) async {
    try {
      await _hiveServices.deleteFavorite(product);
      emit(FavoriteRemoved());
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
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
