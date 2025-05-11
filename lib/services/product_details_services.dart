import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/ApiPaths.dart';

import 'firestore_services.dart';

abstract class ProductDetailsServices {
  Future<ProductItemModel> fetchProductDetails(String productId);

  Future<void> addToCart(String userId, CartItemModel cartItem);
}

class ProductDetailsServicesImpl implements ProductDetailsServices {

  final _fireStoreServices = FireStoreServices.instance;

  @override
  Future<void> addToCart(String userId, CartItemModel cartItem) async {
    await _fireStoreServices.setData(
      cartItem.toMap(),
      ApiPaths.cartItem(userId, cartItem.cartItemId),
    );
  }

  @override
  Future<ProductItemModel> fetchProductDetails(String productId) async {
    final product = await _fireStoreServices.getDocument<ProductItemModel>(
      path: ApiPaths.product(productId),
      builder: ProductItemModel.fromMap,
    );
    return product;
  }
}
