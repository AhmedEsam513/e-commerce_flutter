import 'package:e_commerce/view_models/cart_cubit/cart_cubit.dart';
import 'package:e_commerce/view_models/favorite_cubit/favorite_cubit.dart';
import 'package:e_commerce/view_models/home_tab_cubit/home_tab_cubit.dart';
import 'package:e_commerce/view_models/profile_bloc/profile_bloc.dart';
import 'package:e_commerce/views/pages/cart_page.dart';
import 'package:e_commerce/views/pages/favorites_page.dart';
import 'package:e_commerce/views/pages/home_page.dart';
import 'package:e_commerce/views/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      BlocProvider(
        create: (context) {
          final homeTabCubit = HomeTabCubit();
          homeTabCubit.getHomeTabData();
          return homeTabCubit;
        },
        child: HomePage(),
      ),
      BlocProvider(
        create: (context) => CartCubit(),
        child: CartPage(),
      ),
      BlocProvider(
        create: (context) => FavoriteCubit(),
        child: FavoritesPage(),
      ),
      BlocProvider(
        create: (context) {
          final profileBloc = ProfileBloc();
          profileBloc.add(FetchProfileEvent());
          return profileBloc;
        },
        child: ProfilePage(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 17),
          child: GNav(
            tabs: [
              GButton(icon: Icons.home_outlined, text: "Home"),
              GButton(icon: Icons.shopping_cart_outlined, text: "Cart"),
              GButton(icon: Icons.favorite_border, text: "Favorites"),
              GButton(icon: Icons.person, text: "Profile"),
            ],
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            //rippleColor: Colors.deepPurple!,
            //hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.deepPurple,
            iconSize: 24,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
// PersistentTabView(
// controller: controller,
// tabs: [
// PersistentTabConfig(
// screen: HomePage(),
// item: ItemConfig(
// icon: Icon(Icons.home),
// title: "Home",
// activeForegroundColor: Colors.deepPurple,
// activeColorSecondary: Colors.deepPurple,
// ),
// ),
// PersistentTabConfig(
// screen: BlocProvider(
// create: (context) => CartCubit(),
// child: CartPage(),
// ),
// item: ItemConfig(
// icon: Icon(Icons.shopping_cart_outlined),
// title: "Cart",
// activeForegroundColor: Colors.deepPurple,
// activeColorSecondary: Colors.deepPurple,
// ),
// ),
// PersistentTabConfig(
// screen: FavoritesPage(),
// item: ItemConfig(
// icon: Icon(Icons.favorite_border),
// title: "Favorites",
// activeForegroundColor: Colors.deepPurple,
// activeColorSecondary: Colors.deepPurple,
// ),
// ),
// PersistentTabConfig(
// screen: ProfilePage(),
// item: ItemConfig(
// icon: Icon(Icons.person),
// title: "My Profile",
// activeForegroundColor: Colors.deepPurple,
// activeColorSecondary: Colors.deepPurple,
// ),
// ),
// ],
// navBarBuilder: (navBarConfig) => Style5BottomNavBar(
// navBarConfig: navBarConfig,
// ),
//
// // we use this function to rebuild the cart page(its index =1)
// // when the cart changes, instead of
// // make stateManagement of the bottom_nav_bar = true
// onTabChanged: (index) {
// if (index == 1) {
// setState(() {});
// }
// },
// );
