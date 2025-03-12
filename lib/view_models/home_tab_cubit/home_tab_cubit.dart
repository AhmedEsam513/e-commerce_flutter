import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/home_services.dart';
import 'package:e_commerce/utils/ApiPaths.dart';
import 'package:flutter/material.dart';

part 'home_tab_state.dart';

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(HomeTabInitial());

  final _homeServices = HomeServicesImpl();
  final _authServices = AuthServicesImpl();

  String getUserId() {
    final currentUserId = _authServices.getCurrentUser()!.uid;
    return currentUserId;
  }

  void getHomeTabData() async {
    emit(HomeTabLoading());

    try {
      final fetchedProducts = await _homeServices.fetchProducts();
      final currentUser = await _homeServices.fetchCurrentUser(getUserId());

      emit(HomeTabLoaded(products: fetchedProducts, banners: homeBanners, user: currentUser));
    } catch (e) {
      emit(HomeTabError(e.toString()));
    }

    // Future.delayed(Duration(seconds: 1), () {
    //   emit(HomeTabLoaded(products: products, banners: homeBanners));});
  }
}
