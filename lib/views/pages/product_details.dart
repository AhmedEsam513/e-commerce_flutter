import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/product_details_bloc_builders.dart';
import 'package:e_commerce/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatelessWidget {
  final ProductItemModel product;
  bool isFavorite;

  ProductDetails({super.key, required this.product, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final productDetailsCubit = BlocProvider.of<ProductDetailsCubit>(context);

    // Get the product details
    productDetailsCubit.getProductDetails(product.productId!);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
              bloc: productDetailsCubit,
              listenWhen: (previous, current) =>
                  current is FavoriteAdded ||
                  current is FavoriteRemoved ||
                  current is ProductDetailsLoaded,
              listener: (context, state) {
                if (state is ProductDetailsLoaded) {
                  isFavorite = state.isFavorite;
                } else if (state is FavoriteAdded) {
                  isFavorite = true;
                } else {
                  isFavorite = false;
                }
              },
              buildWhen: (previous, current) =>
                  current is FavoriteAdded ||
                  current is FavoriteRemoved ||
                  current is FavoriteError ||
                  current is ProductDetailsLoaded,
              builder: (context, state) {
                if (state is ProductDetailsLoaded) {
                  return IconButton(
                    onPressed: () {
                      state.isFavorite
                          ? productDetailsCubit.unFavorite(product)
                          : productDetailsCubit.favorite(product);
                    },
                    icon: Icon(
                        state.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: state.isFavorite
                            ? themeData.primaryColor
                            : Colors.black),
                  );
                } else if (state is FavoriteError) {
                  return Text("something went wrong");
                } else if (state is FavoriteAdded) {
                  return IconButton(
                    onPressed: () {
                      productDetailsCubit.unFavorite(product);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: themeData.primaryColor,
                    ),
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      productDetailsCubit.favorite(product);
                    },
                    icon: Icon(Icons.favorite_border),
                  );
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            productDetailsWidget(context, product),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding:
                  EdgeInsets.only(left: 15, right: 15, bottom: 35, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        product.price.toString(),
                        style: themeData.textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " EGP",
                        style: themeData.textTheme.headlineSmall!.copyWith(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                    bloc: productDetailsCubit,
                    buildWhen: (previous, current) =>
                        current is AddedToCartState ||
                        current is AddingToCartState ||
                        current is AddToCartErrorState,
                    builder: (context, state) {
                      if (state is AddingToCartState) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 70),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                          ),
                        );
                      } else if (state is AddedToCartState) {
                        return Container(
                          padding: EdgeInsets.all(15),
                          height: 57,
                          width: 190,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "Added to Cart",
                              style: themeData.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      } else if (state is ProductDetailsLoaded) {
                        return InkWell(
                          onTap: () {
                            // Check if a size is selected
                            if (productDetailsCubit.selectedSize != null) {
                              productDetailsCubit.addToCart(product.productId!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please Select a Size!"),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            height: 57,
                            width: 190,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: deviceSize.width * 0.035),
                                Text(
                                  "Add to Cart",
                                  style:
                                      themeData.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        if (state is AddToCartErrorState) {
                          debugPrint(state.message);
                        }
                        return Center(
                          child: Text("Error with cart"),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

Widget productDetailsWidget(BuildContext context, ProductItemModel product) {
  final themeData = Theme.of(context);
  final deviceSize = MediaQuery.of(context).size;
  final cubit = BlocProvider.of<ProductDetailsCubit>(context);

  return Expanded(
    child: Stack(
      children: [
        // Image
        Image.asset(product.imgPath),

        //Scrollable Column
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: deviceSize.height * 0.45),
            child: Container(
              height: deviceSize.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: themeData.textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                product.category,
                                style: themeData.textTheme.titleMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                              SizedBox(height: deviceSize.height * 0.005),
                            ],
                          ),
                          quantityBlocBuilder(1, product)
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          SizedBox(width: deviceSize.width * 0.01),
                          Text(
                            product.rating.toString(),
                            style: themeData.textTheme.labelLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "  (237 review)",
                            style: themeData.textTheme.labelLarge!.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: deviceSize.height * 0.03),
                      Text(
                        "Size",
                        style: themeData.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: ProductSizes.values
                            .map(
                              (size) => Padding(
                                padding: EdgeInsets.only(top: 3, right: 10),
                                child: InkWell(
                                  onTap: () {
                                    cubit.selectSize(size);
                                  },
                                  child: sizeBlocBuilder(
                                    deviceSize.height * 0.04,
                                    deviceSize.width * 0.08,
                                    size,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: deviceSize.height * 0.03),
                      Text(
                        "Description",
                        style: themeData.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: deviceSize.height * 0.01),
                      Text(
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum"
                        "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                        style: themeData.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
