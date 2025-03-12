class PaymentCardModel {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final bool isChosen;

  PaymentCardModel({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    this.isChosen = false,
  });

  PaymentCardModel copyWith({
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cvv,
    bool? isChosen,
  }) {
    return PaymentCardModel(
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      isChosen: isChosen ?? this.isChosen,
    );
  }
}

List<PaymentCardModel> paymentCards = [
  PaymentCardModel(
    cardNumber: "0000111122225177",
    cardHolder: "Ahmed Esam",
    expiryDate: "01/29",
    cvv: "517",
  ),
  // PaymentCardModel(
  //   cardNumber: "0000111122229845",
  //   cardHolder: "Mohamed Ashraf",
  //   expiryDate: "01/29",
  //   cvv: "517",
  // ),
  // PaymentCardModel(
  //   cardNumber: "0000111122221175",
  //   cardHolder: "Ahmed Ashour",
  //   expiryDate: "01/29",
  //   cvv: "517",
  // ),
  // PaymentCardModel(
  //   cardNumber: "0000111122225389",
  //   cardHolder: "Mohey Amer",
  //   expiryDate: "01/29",
  //   cvv: "517",
  //   isChosen: true,
  // ),
];
