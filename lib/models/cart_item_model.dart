import 'package:e_commerce/models/product_item_model.dart';

class CartItemModel {
  final String cartItemId; // will be the time that the item was added to the cart
  final ProductItemModel product;
  final int quantity;
  final ProductSizes size;
  final double total;

  CartItemModel({
    required this.cartItemId,
    required this.quantity,
    required this.size,
    required this.product,
    required this.total,
  });

  CartItemModel copyWith({
    String? itemId,
    int? quantity,
    ProductSizes? size,
    ProductItemModel? product,
    double? total,
  }) {
    return CartItemModel(
      cartItemId: itemId ?? this.cartItemId,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartItemId': cartItemId,
      'quantity': quantity,
      'size': size.name,
      'product': product.toMap(),
      'total': total,
    };
  }

  static CartItemModel fromMap(Map<String, dynamic> map, String id) {
    return CartItemModel(
      cartItemId: map['cartItemId'],
      quantity: map['quantity'],
      size: ProductSizes.fromString(map['size']),
      product: ProductItemModel.fromMap(map['product']),
      total: map['total'],
    );
  }
}

List<CartItemModel> cart = [];
