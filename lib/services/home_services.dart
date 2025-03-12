import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';

abstract class HomeServices {
  Future<UserModel> fetchCurrentUser(String userId);

  Future<List<ProductItemModel>> fetchProducts();
}

class HomeServicesImpl implements HomeServices {
  final _fireStoreServices = FireStoreServices.instance;

  @override
  Future<UserModel> fetchCurrentUser(String userId) {
    final user = _fireStoreServices.getDocument<UserModel>(
      path: ApiPaths.user(userId),
      builder: UserModel.fromMap,
    );
    return user;
  }

  @override
  Future<List<ProductItemModel>> fetchProducts() async {
    final result = await _fireStoreServices.getCollection<ProductItemModel>(
      path: ApiPaths.products(),
      builder: ProductItemModel.fromMap,
    );

    return result;
  }
}
