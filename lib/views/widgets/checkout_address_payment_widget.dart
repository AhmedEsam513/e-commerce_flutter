import 'package:flutter/material.dart';

class CheckoutAddressPaymentWidget extends StatelessWidget {
  final String heading;
  final String title;
  final VoidCallback onTap;

  const CheckoutAddressPaymentWidget({
    super.key,
    required this.heading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: themeData.textTheme.titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: deviceSize.height * 0.01),
        InkWell(
          onTap: onTap,
          child: Container(
            height: deviceSize.height * 0.13,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(deviceSize.height*0.03),
            child: Column(
              children: [
                Icon(
                  Icons.add,
                  size: 30,
                ),
                Text(
                  title,
                  style: themeData.textTheme.titleMedium,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
