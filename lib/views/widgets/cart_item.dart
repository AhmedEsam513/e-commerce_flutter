import 'package:e_commerce/models/cart_item_model.dart';
import 'package:e_commerce/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/views/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  final int cartItemIndex;
  final CartItemModel cartItem;

  const CartItem(
      {super.key, required this.cartItem, required this.cartItemIndex});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final product = cartItem.product;
    final cartCubit = BlocProvider.of<CartCubit>(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16.0,top: 16,bottom: 16),
      child: Container(
        height: deviceSize.height * 0.12,
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
            children: [
              IconButton(onPressed: (){cartCubit.removeItem(cartItemIndex);}, icon: Icon(Icons.delete)),
              //SizedBox(width: constraints.maxWidth * 0.01),
              Container(
                padding: EdgeInsets.all(constraints.maxHeight * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Image.asset(
                  product.imgPath,
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
                    product.name,
                    style: themeData.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        "Size : ",
                        style: themeData.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Text(
                        "${cartItem.size.name}",
                        style: themeData.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  BlocBuilder<CartCubit, CartState>(
                    bloc: cartCubit,
                    buildWhen: (previous, current) =>
                        current is quantityChangedState &&
                        current.itemIndex == cartItemIndex,
                    builder: (context, state) {
                      if (state is quantityChangedState) {
                        return CounterWidget(
                          value: state.newQuantity,
                          productCubit: cartCubit,
                          index: cartItemIndex,
                        );
                      } else if (state is CartLoaded) {
                        return CounterWidget(
                          value: cartItem.quantity,
                          productCubit: cartCubit,
                          index: cartItemIndex,
                        );
                      } else {
                        return Center(child: Text("Error with Quantity"));
                      }
                    },
                  )
                ],
              ),
              Spacer(),
              BlocBuilder<CartCubit, CartState>(
                buildWhen: (previous, current) => current is quantityChangedState && current.itemIndex == cartItemIndex,
                builder: (context, state) {
                  if(state is quantityChangedState){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          state.newTotal.toString(),
                          style: themeData.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "EGP",
                          style: themeData.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        )
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (product.price * cartItem.quantity).toString(),
                        style: themeData.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "EGP",
                        style: themeData.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      )
                    ],
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
