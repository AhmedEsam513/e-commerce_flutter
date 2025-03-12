import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/product_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  double calculateCartTotal() {
    return cart.fold<double>(
        0,
        (combine, element) =>
            combine + (element.quantity * element.item.price));
  }

  void getCart() {

    //await Future.delayed(Duration(seconds: 1));

    if (cart.isEmpty) {
      emit(CartEmptyState());
    } else {
      emit(CartLoading());
      final cartTotalAmount = calculateCartTotal();
      emit(CartLoaded(dummyList: cart, totalAmount: cartTotalAmount));
    }
  }

  void incrementQuantity(int cartItemIndex) {
    final changedItem = cart[cartItemIndex];

    cart[cartItemIndex] = changedItem.copyWith(
        quantity: changedItem.quantity + 1,
        total: (changedItem.quantity + 1) * changedItem.item.price);

    emit(quantityChangedState(cartItemIndex, cart[cartItemIndex].quantity,
        cart[cartItemIndex].total));

    final cartTotalAmount = calculateCartTotal();

    emit(CartLoaded(dummyList: cart, totalAmount: cartTotalAmount));
  }

  void decrementQuantity(int cartItemIndex) {
    final changedItem = cart[cartItemIndex];

    cart[cartItemIndex] = changedItem.copyWith(
        quantity: changedItem.quantity - 1,
        total: (changedItem.quantity - 1) * changedItem.item.price);
    emit(quantityChangedState(cartItemIndex, cart[cartItemIndex].quantity,
        cart[cartItemIndex].total));

    final cartTotalAmount = calculateCartTotal();

    emit(CartLoaded(dummyList: cart, totalAmount: cartTotalAmount));
  }

  void removeItem(int cartItemIndex){
    cart.removeAt(cartItemIndex);

    if (cart.isEmpty) {
      emit(CartEmptyState());
    } else {
      emit(CartLoading());
      final cartTotalAmount = calculateCartTotal();
      emit(CartLoaded(dummyList: cart, totalAmount: cartTotalAmount));
    }
  }
}
