import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/add_card_cubit/payment_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentModalBottomSheet extends StatelessWidget {
  const PaymentModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final paymentCubit = BlocProvider.of<PaymentCardCubit>(context);

    return BlocBuilder<PaymentCardCubit, PaymentCardState>(
      bloc: paymentCubit,
      buildWhen: (previous, current) =>
          current is CardsFetching || current is CardsFetched,
      builder: (context, state) {
        if (state is CardsFetching) {
          return Container(
            height: deviceSize.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CardsFetched) {
          // <<< CardsFetched State >>>
          return Container(
            height: deviceSize.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Method",
                      style: themeData.textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: deviceSize.height * 0.02),
                    ...List.generate(
                      state.fetchedCards.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.all(deviceSize.height * 0.007),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/images/master-card.png",
                              height: deviceSize.height * 0.07,
                            ),
                            //SizedBox(width: deviceSize.width * 0.03),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.fetchedCards[index].cardHolder),
                                Text(
                                    "**** **** **** ${state.fetchedCards[index].cardNumber.substring(12)}"),
                              ],
                            ),
                            trailing:
                                BlocBuilder<PaymentCardCubit, PaymentCardState>(
                              bloc: paymentCubit,
                              buildWhen: (previous, current) =>
                                  current is CardSelected ||
                                  current is CardsFetched,
                              builder: (context, state) {
                                if (state is CardsFetched) {
                                  return Radio<int>(
                                    value: index,
                                    groupValue: state.initialSelectedCard,
                                    onChanged: (value) {
                                      paymentCubit.selectCard(value!);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                } else if (state is CardSelected) {
                                  return Radio(
                                    value: index,
                                    groupValue: state.selectedCard,
                                    onChanged: (value) {
                                      paymentCubit.selectCard(value!);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                } else {
                                  return Text("Something Wrong with Radio");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceSize.height * 0.03),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.all(deviceSize.height * 0.002),
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text("Add New Card"),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(AppRoutes.addCard)
                              .then((value) =>
                                  BlocProvider.of<PaymentCardCubit>(context)
                                      .fetchCards());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text("There is an unExpected Error"),
          );
        }
      },
    );
  }
}
