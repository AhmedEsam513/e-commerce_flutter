// Flutter
import 'package:flutter/material.dart';

// External Packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    final _PageController = PageController();

    //BlocProvider
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        // BlocBuilder
        child: BlocBuilder<HomeTabCubit, HomeTabState>(
          bloc: BlocProvider.of<HomeTabCubit>(context),
          builder: (context, state) {
            if (state is HomeTabLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HomeTabLoaded) {
              return Column(
                children: [
                  SizedBox(
                    height: isPortrait ? deviceSize.height * 0.25 : deviceSize.height * 0.7,
                    child: PageView(
                      controller: _PageController,
                      //itemCount: state.banners.length,
                      children:state.banners,
                    ),
                  ),
                  SizedBox(height: deviceSize.height * 0.01),
                  SmoothPageIndicator(
                    controller: _PageController,
                    count: state.banners.length,
                    effect: SlideEffect(
                      activeDotColor: Colors.deepPurple,
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  SizedBox(height: deviceSize.height * 0.02),
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
                    itemBuilder: (context, index) => ProductItem(
                      product: state.products[index],
                    ),
                  )
                ],
              );
            } else if (state is HomeTabError) {
              return Center(child: Text(state.message));
            } else {
              return Center(
                child: SizedBox.shrink(),
              );
            }
          },
        ),
      ),
    );
  }
}

// FlutterCarousel.builder(
// itemCount: homeBanners.length,
// itemBuilder: (context, index, pageViewIndex) => Padding(
// padding: EdgeInsetsDirectional.only(end: 15),
// child: homeBanners[index],
// ),
// options: FlutterCarouselOptions(
// height: deviceSize.height * 0.19,
// controller: FlutterCarouselController(),
// slideIndicator: CircularWaveSlideIndicator(),
// indicatorMargin: 20,
// autoPlay: true,
// //floatingIndicator: false
// ),
// ),
