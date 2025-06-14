import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/favorite_cubit/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteItem extends StatelessWidget {
  final ProductItemModel product;

  const FavoriteItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5, end: 5, top: 5),
      child: SizedBox(
        height:
            isPortrait ? deviceSize.height * 0.135 : deviceSize.height * 0.41,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.productDetails, arguments: product)
                .then(
                  (value) => favoriteCubit.getFavorites(),
                );
          },
          child: Card(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(11.0),

              //LayoutBuilder & Row
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    //image
                    Image.asset(
                      product.imgPath,
                      width: constraints.maxWidth * 0.28,
                    ),

                    SizedBox(width: constraints.maxWidth * 0.02),

                    //name and price
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //name
                          SizedBox(
                            //when i print the {constraints.maxHeight}
                            // before wrapping with SizedBox it equals (Infinity)

                            height: constraints.maxHeight * 0.31,
                            child: FittedBox(
                              child: Text(product.name,
                                  style: themeData.textTheme.titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                          ),

                          SizedBox(height: constraints.maxHeight * 0.1),

                          //price
                          SizedBox(
                            height: constraints.maxHeight * 0.31,
                            child: FittedBox(
                              child: Text("EGP ${product.price}",
                                  style: themeData.textTheme.titleMedium!
                                      .copyWith(
                                          color: themeData.primaryColor,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ]),

                    Spacer(),
                    IconButton(
                        onPressed: () {
                          favoriteCubit.unFavorite(product);
                          favoriteCubit.getFavorites();
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: themeData.primaryColor,
                          size: 30,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
