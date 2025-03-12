import 'package:flutter/material.dart';

class CounterWidget extends StatelessWidget {
  final int value;
  final dynamic productCubit;
  final int index;

  const CounterWidget({
    super.key,
    required this.value,
    this.productCubit,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6.5, top: 6.5, bottom: 6.5),
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle
                      //borderRadius: BorderRadius.circular(10),
                      ),
              child: IconButton(
                onPressed: () {
                  if (value > 1) productCubit.decrementQuantity(index);
                },
                icon: Icon(Icons.remove),
                iconSize: 20,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: themeData.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.5, top: 6.5, bottom: 6.5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  productCubit.incrementQuantity(index);
                },
                icon: Icon(Icons.add),
                iconSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
