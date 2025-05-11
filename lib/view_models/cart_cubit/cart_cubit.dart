import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final _fireStoreServices = FireStoreServices.instance;
  final _authServices = AuthServicesImpl();

  List<CartItemModel> fetchedCart = [];

  double calculateCartTotal() {
    return fetchedCart.fold<double>(
        0,
        (combine, element) =>
            combine + (element.quantity * element.product.price));
  }

  void getCart() async {
    emit(CartLoading());
    try {
      final currentUser = _authServices.getCurrentUser();
      final cartIsEmpty = !(await _fireStoreServices
          .doesCollectionExist("users/${currentUser!.uid}/cart"));

      if (cartIsEmpty) {
        emit(CartEmptyState());
      } else {
        fetchedCart = await _fireStoreServices.getCollection<CartItemModel>(
            path: "users/${currentUser.uid}/cart",
            builder: CartItemModel.fromMap);
        final cartTotalAmount = calculateCartTotal();
        emit(CartLoaded(cartList: fetchedCart, totalAmount: cartTotalAmount));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void incrementQuantity(int cartItemIndex) {
    final changedItem = fetchedCart[cartItemIndex];

    fetchedCart[cartItemIndex] = changedItem.copyWith(
        quantity: changedItem.quantity + 1,
        total: (changedItem.quantity + 1) * changedItem.product.price);

    emit(quantityChangedState(cartItemIndex,
        fetchedCart[cartItemIndex].quantity, fetchedCart[cartItemIndex].total));

    final cartTotalAmount = calculateCartTotal();

    emit(CartLoaded(cartList: fetchedCart, totalAmount: cartTotalAmount));
  }

  void decrementQuantity(int cartItemIndex) {
    final changedItem = fetchedCart[cartItemIndex];

    fetchedCart[cartItemIndex] = changedItem.copyWith(
        quantity: changedItem.quantity - 1,
        total: (changedItem.quantity - 1) * changedItem.product.price);
    emit(quantityChangedState(cartItemIndex,
        fetchedCart[cartItemIndex].quantity, fetchedCart[cartItemIndex].total));

    final cartTotalAmount = calculateCartTotal();

    emit(CartLoaded(cartList: fetchedCart, totalAmount: cartTotalAmount));
  }

  void removeItem(int cartItemIndex) async {
    //emit(CartLoading());

    try {
      final currentUser = _authServices.getCurrentUser();
      await _fireStoreServices.deleteData(ApiPaths.cartItem(
          currentUser!.uid, fetchedCart[cartItemIndex].cartItemId));

      fetchedCart.removeAt(cartItemIndex);

      if (fetchedCart.isEmpty) {
        emit(CartEmptyState());
      } else {
        final cartTotalAmount = calculateCartTotal();
        emit(CartLoaded(cartList: fetchedCart, totalAmount: cartTotalAmount));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void checkOut() async {
    final uid = _authServices.getCurrentUser()!.uid;
    try {
      fetchedCart.forEach(
        (item) async {
          await _fireStoreServices.setData(
            item.toMap(),
            ApiPaths.cartItem(uid, item.cartItemId),
          );
        },
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
