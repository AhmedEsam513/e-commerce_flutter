// Flutter
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// External Packages
import 'package:flutter_bloc/flutter_bloc.dart';

// Internal Files
import 'package:e_commerce/view_models/home_tab_cubit/home_tab_cubit.dart';
import 'package:e_commerce/views/widgets/product_item.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    //BlocProvider
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        // BlocBuilder
        child: BlocBuilder<HomeTabCubit, HomeTabState>(
          bloc: BlocProvider.of<HomeTabCubit>(context),
          buildWhen: (previous, current) =>
              current is HomeTabLoading ||
              current is HomeTabLoaded ||
              current is HomeTabError,
          builder: (context, state) {
            if (state is HomeTabLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HomeTabLoaded) {
              return Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: deviceSize.height * 0.23,
                      autoPlay: true,
                    ),
                    items: state.banners,
                  ),
                  //SizedBox(height: deviceSize.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Arrivals",
                        style: themeData.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "See All",
                        style: themeData.textTheme.labelLarge!.copyWith(
                          color: themeData.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPortrait ? 2 : 4,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      var isFavorite =
                          state.favoritesIDs.contains(product.productId);
                      return ProductItem(
                        product: product,
                        isFavorite: isFavorite,
                      );
                    },
                  )
                ],
              );
            } else if (state is HomeTabError) {
              return Center(child: Text(state.message));
            } else {
              return Center(
                child: Text("Something went wrong"),
              );
            }
          },
        ),
      ),
    );
  }
}
