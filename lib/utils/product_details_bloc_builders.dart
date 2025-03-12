import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:e_commerce/views/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocBuilder sizeBlocBuilder(double height, double width, ProductSizes size) {
  return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
    buildWhen: (previous, current) => current is SizeSelectedState,
    builder: (context, state) {
      if (state is SizeSelectedState) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state.selectedSize == size
                ? Colors.deepPurple
                : Colors.grey[300],
          ),
          child: Center(
            child: Text(
              size.name,
              style: TextStyle(
                  color:
                      state.selectedSize == size ? Colors.white : Colors.black),
            ),
          ),
        );
      } else if (state is ProductDetailsLoaded) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: Center(
            child: Text(size.name),
          ),
        );
      } else {
        return Center(
          child: Text("Error with Size"),
        );
      }
    },
  );
}

BlocBuilder quantityBlocBuilder(int productIndex, ProductItemModel product) {
  return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
    buildWhen: (previous, current) => current is QuantityChangedState,
    builder: (context, state) {
      if (state is QuantityChangedState) {
        return CounterWidget(
          value: state.newQuantity,
          productCubit: BlocProvider.of<ProductDetailsCubit>(context),
          index: 0,
        );
      } else if (state is ProductDetailsLoaded) {
        return CounterWidget(
          value: 1,
          productCubit: BlocProvider.of<ProductDetailsCubit>(context),
          index: 0,
        );
      } else {
        return Center(child: Text("Error with Quantity"));
      }
    },
  );
}
