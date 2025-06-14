import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/home_tab_cubit/home_tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel product;
  bool isFavorite;

  ProductItem({super.key, required this.product, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final cubit = BlocProvider.of<HomeTabCubit>(context);

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: InkWell(
          onTap: () {
            // Navigate to the product details page and Refresh the home tab
            Navigator.of(context, rootNavigator: true).pushNamed(
                AppRoutes.productDetails,
                arguments: product).then((value) => cubit.getHomeTabData());
          },
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(7),
                    height: constraints.maxHeight * 0.65,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      product.imgPath,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: BlocConsumer<HomeTabCubit, HomeTabState>(
                      bloc: cubit,
                      listenWhen: (previous, current) =>
                          (current is FavoriteAdded &&
                              product.productId == current.productId) ||
                          (current is FavoriteRemoved &&
                              product.productId == current.productId),
                      listener: (context, state) {
                        state is FavoriteAdded
                            ? isFavorite = true
                            : isFavorite = false;
                      },
                      buildWhen: (previous, current) =>
                          (current is FavoriteAdded &&
                              product.productId == current.productId) ||
                          (current is FavoriteRemoved &&
                              product.productId == current.productId),
                      builder: (context, state) {
                        if (state is FavoriteError) {
                          return Text(state.message);
                        } else if (state is FavoriteAdded || isFavorite) {
                          return IconButton(
                            onPressed: () {
                              cubit.unFavorite(product);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.deepPurple,
                            ),
                          );
                        } else {
                          return IconButton(
                            onPressed: () {
                              cubit.favorite(product);
                            },
                            icon: Icon(Icons.favorite_border),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: constraints.maxHeight * 0.01),
              Text(
                product.name,
                style: themeData.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                product.category,
                style: themeData.textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.02,
              ),
              Text(
                "${product.price} EGP",
                style: themeData.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
