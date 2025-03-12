import 'package:e_commerce/models/product_item_model.dart';

class CartItemModel {
  final int productId;
  final ProductItemModel item;
  final int quantity;
  final ProductSizes size;
  final double total;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.size,
    required this.item,
    required this.total,
  });

  CartItemModel copyWith({
    int? quantity,
    ProductSizes? size,
    ProductItemModel? item,
    double? total,
  }) {
    return CartItemModel(
      productId: this.productId,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      item: item ?? this.item,
      total: total ?? this.total,
    );
  }
}

List<CartItemModel> cart = [];
