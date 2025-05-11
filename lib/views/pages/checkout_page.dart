import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/add_card_cubit/payment_card_cubit.dart';
import 'package:e_commerce/view_models/checkout_cubit/checkout_cubit.dart';
import 'package:e_commerce/views/widgets/checkout_address_payment_widget.dart';
import 'package:e_commerce/views/widgets/main_button.dart';
import 'package:e_commerce/views/widgets/payment_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) {
        final cubit = CheckoutCubit();
        cubit.getCheckoutItems();
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Checkout"),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Builder(builder: (context) {
                    final checkoutCubit =
                        BlocProvider.of<CheckoutCubit>(context);

                    return BlocBuilder<CheckoutCubit, CheckoutState>(
                      bloc: checkoutCubit,
                      buildWhen: (previous, current) =>
                          current is CheckoutLoaded ||
                          current is CheckoutLoading ||
                          current is CheckoutError,
                      builder: (context, state) {
                        if (state is CheckoutLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CheckoutLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckoutAddressPaymentWidget(
                                heading: "Address",
                                title: "Add Shipping Address",
                                onTap: () {},
                              ),
                              SizedBox(height: deviceSize.height * 0.02),

                              checkoutProductsWidget(context, state),
                              SizedBox(height: deviceSize.height * 0.01),
// <<  Payment Section >>>
                              state.isCardsEmpty
                                  ? CheckoutAddressPaymentWidget(
                                      heading: "Payment",
                                      title: "Add Payment Method",
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushNamed(AppRoutes.addCard)
                                            .then((value) => checkoutCubit
                                                .getCheckoutItems());
                                      },
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: ListTile(
                                        leading: Image.asset(
                                            "assets/images/master-card.png"),
                                        title: Text(state
                                            .initialSelectedCard.cardHolder),
                                        subtitle: Text(
                                            "**** **** **** ${state.initialSelectedCard.cardNumber.substring(12)}"),
                                        trailing: Icon(Icons.chevron_right),
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (_) => BlocProvider(
                                              create: (_) {
                                                final cubit =
                                                    PaymentCardCubit();
                                                cubit.fetchCards();
                                                return cubit;
                                              },
                                              child: PaymentModalBottomSheet(),
                                            ),
                                          ).then((value) =>
                                              checkoutCubit.getCheckoutItems());
                                        },
                                      ),
                                    ),

                              SizedBox(height: deviceSize.height * 0.01),
                              Divider(),
                              SizedBox(height: deviceSize.height * 0.01),

// <<  Total Section >>>
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: themeData.textTheme.titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                  ),
                                  Text(
                                    "EGP ${state.totalAmount}",
                                    style: themeData.textTheme.titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (state is CheckoutError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          return Center(
                            child: Text("There is an unExpected Error"),
                          );
                        }
                      },
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 30, top: 15),
              child: MainButton(
                onPressed: () {},
                text: "Place Order",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkoutProductsWidget(BuildContext context, CheckoutLoaded state) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Products (${state.numberOfItems})",
          style: themeData.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.checkoutList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 14.0, top: 10, left: 14.0),
            child: Container(
              height: deviceSize.height * 0.1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.06),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: Image.asset(
                          state.checkoutList[index].product.imgPath,
                          height: constraints.maxHeight,
                          width: constraints.maxWidth * 0.23,
                        ),
                      ),
                      SizedBox(width: constraints.maxWidth * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.checkoutList[index].product.name,
                            style: themeData.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                "Size : ",
                                style: themeData.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                state.checkoutList[index].size.name,
                                style: themeData.textTheme.titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Quantity : ",
                                style: themeData.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                "${state.checkoutList[index].quantity}",
                                style: themeData.textTheme.titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            (state.checkoutList[index].product.price *
                                    state.checkoutList[index].quantity)
                                .toString(),
                            style: themeData.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "EGP",
                            style: themeData.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
