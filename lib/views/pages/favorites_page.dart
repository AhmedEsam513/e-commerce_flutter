import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "My Favorites",
          style: themeData.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_favorite.png",
            height: deviceSize.height * 0.28,
            width: deviceSize.width,
          ),
          SizedBox(height: deviceSize.height * 0.07),
          Text(
            "Your Favorites is Empty",
            style: themeData.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
