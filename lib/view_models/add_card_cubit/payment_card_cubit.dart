import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/payment_card_model.dart';

part 'payment_card_state.dart';

class PaymentCardCubit extends Cubit<PaymentCardState> {
  PaymentCardCubit() : super(PaymentCardInitial());

  void addCard(PaymentCardModel newCard) {
    emit(PaymentCardAdding());
    paymentCards.add(newCard);
    Future.delayed(Duration(seconds: 5), () {
      emit(PaymentCardAdded());
    });
  }

  void fetchCards() {
    emit(CardsFetching());

    int selectedCard = paymentCards.indexWhere((element) => element.isChosen);
    selectedCard = selectedCard == -1 ? 0 : selectedCard;

    Future.delayed(
      Duration(seconds: 1),
      () {
        emit(CardsFetched(paymentCards, selectedCard));
      },
    );
  }

  void selectCard(int index) {

    //paymentCards.forEach((element)=> element=element.copyWith(isChosen: false)) ;


    paymentCards[index] = paymentCards[index].copyWith(isChosen: true);

    for (int i = 0; i < paymentCards.length; i++) {
      if(i != index){
        paymentCards[i]=paymentCards[i].copyWith(isChosen: false);
      }
    }

    emit(CardSelected(selectedCard: index));
  }
}
