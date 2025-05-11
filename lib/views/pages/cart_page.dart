import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/views/widgets/cart_item.dart';
import 'package:e_commerce/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    final cubit = BlocProvider.of<CartCubit>(context);

    // Fetching the cart items from the FireStore
    cubit.getCart();


    return BlocBuilder<CartCubit, CartState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is CartLoaded ||
          current is CartLoading ||
          current is CartError ||
          current is CartEmptyState,
      builder: (context, state) {
        if (state is CartLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CartEmptyState) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("My Cart",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: deviceSize.height * 0.1),
                Center(
                  child: Image.asset(
                    "assets/images/cart_page/empty-cart_3.png",
                    height: deviceSize.height * 0.45,
                    width: deviceSize.width * 0.83,
                  ),
                ),
                Text(
                  "Your Cart is Feeling Light",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                )
              ],
            ),
          );
        } else if (state is CartLoaded) {
          final cart = state.cartList;
          return Scaffold(
            //extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "My Cart",
                style: themeData.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.builder(
                          //itemExtent: deviceSize.height*0.18,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CartItem(
                                  cartItem: cart[index],
                                  cartItemIndex: index,
                                ),
                                Divider(
                                  endIndent: deviceSize.width * 0.05,
                                  indent: deviceSize.width * 0.05,
                                )
                              ],
                            );
                          },
                        ),
                        totalAndSubtotalWidget(
                          themeData,
                          title: "Subtotal",
                          value: "EGP ${state.totalAmount.toStringAsFixed(2)}",
                        ),
                        SizedBox(height: deviceSize.height * 0.017),
                        totalAndSubtotalWidget(themeData,
                            title: "Shipping Fee", value: "EGP 50"),
                        SizedBox(height: deviceSize.height * 0.01),
                        Dash(length: deviceSize.width * 0.92),
                        SizedBox(height: deviceSize.height * 0.015),
                        totalAndSubtotalWidget(
                          themeData,
                          title: "Total Amount",
                          value:
                              "EGP ${(state.totalAmount + 50).toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 25, top: 15),
                  child: MainButton(
                    onPressed: () {
                      cubit.checkOut();
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(AppRoutes.checkout);
                    },
                    text: "Checkout Now",
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text("Something went wrong"));
        }
      },
    );
  }
}

Widget totalAndSubtotalWidget(ThemeData themeData,
    {required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: themeData.textTheme.titleMedium!.copyWith(color: Colors.grey),
        ),
        Text(value, style: themeData.textTheme.titleMedium),
      ],
    ),
  );
}

