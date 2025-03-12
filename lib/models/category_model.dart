class CategoryModel {
  final String imgPath;
  final String name;
  final String productsNum;

  CategoryModel({
    required this.imgPath,
    required this.name,
    required this.productsNum,
  });
}

List<CategoryModel> categories = [
  CategoryModel(imgPath: "assets/images/categories/t_shirt_bg.jpeg", name: "T-Shirts", productsNum: "29"),
  CategoryModel(imgPath: "assets/images/categories/pants_bg.jpeg", name: "Pants", productsNum: "45"),
  CategoryModel(imgPath: "assets/images/categories/shoes_bg.jpeg", name: "Shoes", productsNum: "15"),
  CategoryModel(imgPath: "assets/images/categories/pullover_bg.jpeg", name: "Pullovers", productsNum: "18"),
  CategoryModel(imgPath: "assets/images/categories/jackets_bg.jpeg", name: "Jackets", productsNum: "55"),
  CategoryModel(imgPath: "assets/images/categories/Hoodie_bg.jpeg", name: "Hoodies", productsNum: "10"),
];
