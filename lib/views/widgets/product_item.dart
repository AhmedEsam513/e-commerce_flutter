import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: InkWell(
          onTap: (){Navigator.of(context,rootNavigator: true).pushNamed(AppRoutes.productDetails,arguments: product.productId);},
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(7),
                    height: constraints.maxHeight * 0.65,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      product.imgPath,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border),
                    ),
                  ),
                ],
              ),
              SizedBox(height: constraints.maxHeight*0.01),
              Text(
                product.name,
                style: themeData.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                product.category,
                style: themeData.textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.02,
              ),
              Text(
                "${product.price} EGP",
                style: themeData.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
