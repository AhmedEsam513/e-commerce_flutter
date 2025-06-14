import 'package:e_commerce/view_models/favorite_cubit/favorite_cubit.dart';
import 'package:e_commerce/views/widgets/favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    final favoriteCubit = BlocProvider.of<FavoriteCubit>(context);

    // Fetch Favorites from Hive
    favoriteCubit.getFavorites();

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
      body: BlocConsumer<FavoriteCubit, FavoriteState>(
        bloc: favoriteCubit,
        listenWhen: (previous, current) => current is FavoriteError,
        listener: (context, state) {
          if (state is FavoriteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoriteLoaded) {
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (_, index) =>
                  FavoriteItem(product: state.favorites[index]),
            );
          } else if (state is FavoriteError) {
            return emptyAndErrorWidget(deviceSize, themeData, "Error");
          } else {
            return emptyAndErrorWidget(deviceSize, themeData, "Empty");
          }
        },
      ),
    );
  }
}

// Widget for Empty and Error States with message
Widget emptyAndErrorWidget(Size deviceSize, ThemeData themeData, String text) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/images/empty_favorite.png",
        height: deviceSize.height * 0.28,
        width: deviceSize.width,
      ),
      SizedBox(height: deviceSize.height * 0.07),
      Text(
        text == "Empty" ? "Your Favorites is Empty" : "Something went wrong",
        style: themeData.textTheme.titleLarge!
            .copyWith(fontWeight: FontWeight.w500),
      )
    ],
  );
}
