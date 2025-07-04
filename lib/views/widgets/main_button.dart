import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final bool isEnabled;

//  final Color color;

  const MainButton({
    super.key,
    required this.onPressed,
    this.text,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: text!=null && isEnabled? Colors.deepPurple:Colors.grey[200],
        minimumSize: Size(double.infinity, deviceSize.height * 0.07),
      ),
      child: text!=null? Text(
        text!,
        style: themeData.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold, color: isEnabled? Colors.white:Colors.grey),
      ):CircularProgressIndicator(),
    );
  }
}
