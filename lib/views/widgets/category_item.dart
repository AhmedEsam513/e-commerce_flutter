import 'package:e_commerce/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final int categoyrIndex;

  const CategoryItem({super.key, required this.categoyrIndex});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: InkWell(
        onTap: () {},
        child: Card(
          elevation: 5,
          child: Stack(
            children: [
              Transform.flip(
                flipX: categoyrIndex % 2 == 0 ? false : true,
                child: Container(
                  height: deviceSize.height*0.125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        categories[categoyrIndex].imgPath,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: deviceSize.height*0.03,
                left: categoyrIndex % 2 == 0 ? deviceSize.width*0.08 : deviceSize.width*0.58,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categories[categoyrIndex].name,
                      style: themeData.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${categories[categoyrIndex].productsNum}  Products",
                      style: themeData.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
