import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/payment_card_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  double calculateCartTotal() {
    return cart.fold<double>(
        0,
        (combine, element) =>
            combine + (element.quantity * element.item.price));
  }

  int calculateNumberOfItems() {
    return cart.fold(
        0, (cumulative, cartElement) => cumulative + cartElement.quantity);
  }

  void getCheckoutItems() {
    emit(CheckoutLoading());

    int selectedCard = 0;

    if (paymentCards.isNotEmpty) {
      selectedCard = paymentCards.indexWhere((element) => element.isChosen);
      selectedCard = selectedCard == -1 ? 0 : selectedCard;
    }
    emit(CheckoutLoaded(cart, calculateNumberOfItems(), calculateCartTotal(),
        paymentCards.isEmpty, paymentCards[selectedCard]));
  }
}
