part of 'checkout_cubit.dart';

sealed class CheckoutState {
  const CheckoutState();
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<CartItemModel> checkoutList;
  final int numberOfItems;
  final double totalAmount;
  final bool isCardsEmpty;
  // final int initialSelectedCard;
  final PaymentCardModel initialSelectedCard;

  const CheckoutLoaded(
    this.checkoutList,
    this.numberOfItems,
    this.totalAmount,
    this.isCardsEmpty,
    this.initialSelectedCard,
    // this.cards,
    // this.initialSelectedCard,
  );
}

final class CheckoutError extends CheckoutState {
  final String errorMessage;

  const CheckoutError(this.errorMessage);
}
