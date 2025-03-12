import 'package:e_commerce/models/category_model.dart';
import 'package:e_commerce/views/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) => CategoryItem(
        categoyrIndex: index,
      ),
    );
  }
}
