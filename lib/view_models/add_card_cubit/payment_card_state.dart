part of 'payment_card_cubit.dart';

sealed class PaymentCardState {
  const PaymentCardState();
}

final class PaymentCardInitial extends PaymentCardState {}


// States for adding new card (used in AddCardPage)

final class PaymentCardAdding extends PaymentCardState {}

final class PaymentCardAdded extends PaymentCardState {}

final class PaymentCardError extends PaymentCardState {
  final String errorMessage;
  const PaymentCardError(this.errorMessage);
}


// States for getting all cards (used in CheckoutPage, specifically in the ModalBottomSheet)

final class CardsFetching extends PaymentCardState {}

final class CardsFetched extends PaymentCardState {
  final List<PaymentCardModel> fetchedCards;
  final int initialSelectedCard;
  const CardsFetched(this.fetchedCards, this.initialSelectedCard);

}


//final class CardsError extends PaymentCardState {}

final class CardSelected extends PaymentCardState {
  final int selectedCard;

  const CardSelected({required this.selectedCard});
}