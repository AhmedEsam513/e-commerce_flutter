import 'package:e_commerce/main.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:e_commerce/views/pages/add_new_card_page.dart';
import 'package:e_commerce/views/pages/bottom_navbar.dart';
import 'package:e_commerce/views/pages/checkout_page.dart';
import 'package:e_commerce/views/pages/login_page.dart';
import 'package:e_commerce/views/pages/product_details.dart';
import 'package:e_commerce/views/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.appStart:
        return MaterialPageRoute(builder: (context)=> MyApp());
      case AppRoutes.bottomNavbar:
        return MaterialPageRoute(builder: (context) => BottomNavbar());

      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (context) => CheckoutPage());

      case AppRoutes.addCard:
        return MaterialPageRoute(builder: (context) => AddNewCardPage());

      case AppRoutes.logIn:
        return MaterialPageRoute(builder: (context) => LoginPage());

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (context) => SignUpPage());

      case AppRoutes.productDetails:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ProductDetailsCubit(),
            child: ProductDetails(productId: productId),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text("No Route Found for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
