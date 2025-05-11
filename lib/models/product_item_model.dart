import 'package:flutter/cupertino.dart';

enum ProductSizes {
  S,
  M,
  L,
  XL;

  static ProductSizes fromString(String size) {
    switch (size.toUpperCase()) {
      case "S":
        return ProductSizes.S;
      case "M":
        return ProductSizes.M;
      case "L":
        return ProductSizes.L;
      case "XL":
        return ProductSizes.XL;
      default:
        return ProductSizes.M;
    }
  }
}

class ProductItemModel {
  final String? productId;
  final String imgPath;
  final bool isFavorite;
  final String name;
  final String category;
  final double price;
  final String description;
  final double rating;

  ProductItemModel({
    this.productId,
    required this.imgPath,
    this.isFavorite = false,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.rating = 4.8,
  });

  ProductItemModel copyWith({
    String? productId,
    String? name,
    String? imgPath,
    double? price,
    String? description,
    bool? isFavorite,
    double? rating,
  }) {
    return ProductItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imgPath: imgPath ?? this.imgPath,
      price: price ?? this.price,
      description: description ?? this.description,
      category: this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "imgPath": imgPath,
      "price": price,
      "description": description,
      "category": category,
      "rating": rating,
    };
  }

  static ProductItemModel fromMap(Map<String, dynamic> data, [String? id]) {
    return ProductItemModel(
      productId: id,
      imgPath: data["imgPath"],
      name: data["name"],
      category: data["category"],
      price: data["price"],
      description: data["description"],
    );
  }
}

List<ProductItemModel> products = [
  ProductItemModel(
      imgPath: "assets/images/products/black_t_shirt.png",
      name: "Black T_Shirt",
      category: "T_shirts",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/blue_jeans.png",
      name: "Blue Jeans",
      category: "Pants",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/black_pants.png",
      name: "Black Pants",
      category: "Pants",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/blue_running_shoes.png",
      name: "Running Shoes",
      category: "Shoes",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/white_sneakers.png",
      name: "Running Shoes",
      category: "Shoes",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/red_running_shoes.png",
      name: "Running Shoes",
      category: "Shoes",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/bw_running_shoes.png",
      name: "Running Shoes",
      category: "Shoes",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/blue_sports_t_shirt.png",
      name: "Blue T_Shirt",
      category: "T_shirts",
      price: 199.99,
      description: "This is a black T_Shirt"),
  ProductItemModel(
      imgPath: "assets/images/products/green_waterproof_jacket.png",
      name: "Waterproof Jacket",
      category: "Jackets",
      price: 199.99,
      description: "This is a black T_Shirt"),
];

List<Widget> homeBanners = [
  Image.asset("assets/images/home_banners/banner_1.jpg"),
  Image.asset("assets/images/home_banners/banner_2.jpg"),
  Image.asset("assets/images/home_banners/banner_3.jpg"),
  Image.asset("assets/images/home_banners/banner_4.jpg"),
];
