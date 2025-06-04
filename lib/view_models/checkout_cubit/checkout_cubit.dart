import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/models/payment_card_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/firestore_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final _fireStoreServices = FireStoreServices.instance;
  final _authServices = AuthServicesImpl();


  List<CartItemModel> fetchedCart = [];

  double calculateCartTotal() {
    return fetchedCart.fold<double>(
        0,
        (combine, element) =>
            combine + (element.quantity * element.product.price));
  }

  int calculateNumberOfItems() {
    return fetchedCart.fold(
        0, (cumulative, cartElement) => cumulative + cartElement.quantity);
  }

  void getCheckoutItems() async {
    emit(CheckoutLoading());

    final currentUser = _authServices.getCurrentUser()!;

    try{
      fetchedCart = await _fireStoreServices.getCollection<CartItemModel>(path: ApiPaths.userCart(currentUser.uid), builder:CartItemModel.fromMap);

      int selectedCard = 0;

      if (paymentCards.isNotEmpty) {
        selectedCard = paymentCards.indexWhere((element) => element.isChosen);
        selectedCard = selectedCard == -1 ? 0 : selectedCard;
      }
      emit(CheckoutLoaded(fetchedCart, calculateNumberOfItems(), calculateCartTotal(),
          paymentCards.isEmpty, paymentCards[selectedCard]));

    }
    catch(e){
    emit(CheckoutError(e.toString()));
    }



  }
}
