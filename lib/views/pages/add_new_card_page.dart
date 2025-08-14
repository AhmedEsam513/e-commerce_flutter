import 'package:e_commerce/models/payment_card_model.dart';
import 'package:e_commerce/view_models/add_card_cubit/payment_card_cubit.dart';
import 'package:e_commerce/views/widgets/custom_text_field_widget.dart';
import 'package:e_commerce/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //final themeData = Theme.of(context);
    //final deviceSize = MediaQuery.of(context).size;
    final navigator = Navigator.of(context);

    return BlocProvider(
      create: (context) => PaymentCardCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Add New Card"),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFieldWidget(
                        controller: _cardNumberController,
                        heading: "Card Number",
                        hint: "Enter Card Number",
                        prefixIcon: Icons.credit_card,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "required field";
                          } else if (value.length != 16 || !value.isNumeric) {
                            return "Invalid Card Number";
                          } else {
                            return null;
                          }
                        },
                      ),
                      CustomTextFieldWidget(
                        controller: _cardHolderNameController,
                        heading: "Card Holder Name",
                        hint: "Enter Card Holder Name",
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "required field";
                          } else if (value.isNotEmpty) {
                            List<bool> splitValue = value
                                .split(" ")
                                .map((element) => element.isAlpha)
                                .toList();

                            if (splitValue.contains(false)) {
                              return "Invalid Card Holder Name";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                      ),
                      CustomTextFieldWidget(
                        controller: _expiryDateController,
                        heading: "Expiry Date",
                        hint: "MM/YY",
                        prefixIcon: Icons.calendar_month,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "required field";
                          } else {
                            return null;
                          }
                        },
                      ),
                      CustomTextFieldWidget(
                        controller: _cvvController,
                        heading: "CVV",
                        hint: "Enter CVV",
                        prefixIcon: Icons.password_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "required field";
                          } else if (value.length != 3 || !value.isInt) {
                            return "Invalid CVV";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Spacer(),
                      Builder(builder: (context) {
                        final cardCubit =
                            BlocProvider.of<PaymentCardCubit>(context);
                        return BlocConsumer<PaymentCardCubit, PaymentCardState>(
                          bloc: cardCubit,
                          listenWhen: (previous, current) =>
                              current is PaymentCardAdded,
                          listener: (context, state) {
                            navigator.pop();
                          },
                          buildWhen: (previous, current) =>
                              current is PaymentCardAdding ||
                              current is PaymentCardAdded,
                          builder: (context, state) {
                            if (state is PaymentCardAdding) {
                              return MainButton(onPressed: () {});
                            } else {
                              return MainButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    cardCubit.addCard(
                                      PaymentCardModel(
                                        cardNumber: _cardNumberController.text,
                                        cardHolder:
                                            _cardHolderNameController.text,
                                        expiryDate: _expiryDateController.text,
                                        cvv: _cvvController.text,
                                      ),
                                    );
                                  }
                                },
                                text: "Add Card",
                              );
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _expiryDateController.dispose();
    _cardHolderNameController.dispose();
    _cvvController.dispose();
    _cardNumberController.dispose();

    super.dispose();
  }
}
//
// showDialog(
//   context: context,
//   builder: (context) => AlertDialog(
//     title: Image.asset(
//       "assets/images/checked.png",
//       height: deviceSize.height * 0.1,
//       //width: deviceSize.width * 0.3,
//     ),
//     //titleTextStyle: themeData.textTheme.titleMedium,
//     content: Text("Card Added Successfully!"),
//     contentTextStyle: TextStyle(
//         fontWeight: FontWeight.bold, color: Colors.black),
//     contentPadding: EdgeInsets.symmetric(
//         horizontal: 60, vertical: 30),
//     //icon: Icon(Icons.check,color: Colors.green,),
//   ),
// );
