class ApiPaths{
  static String user(String uid) => "users/$uid";
  static String cartItem(String uid,String itemId) => "users/$uid/cart/$itemId";
  static String products() => "products/";
  static String product(String productId) => "products/$productId";
  static String userCart(String uid) => "users/$uid/cart/";
}