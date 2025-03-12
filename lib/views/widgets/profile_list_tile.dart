import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isRed;

  const ProfileListTile({
    super.key,
    required this.title,
    required this.icon,
    this.subTitle,
    this.onTap,
    this.isRed=false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color:isRed? Colors.red: Colors.deepPurple,
        //size: 30,
      ),
      title: Text(title),
      titleTextStyle: themeData.textTheme.titleMedium!
          .copyWith(fontWeight: FontWeight.bold,color: isRed? Colors.red: Colors.black),
      subtitle: subTitle!=null? Text(subTitle!): null,
      subtitleTextStyle: themeData.textTheme.titleSmall!
          .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
      trailing: Icon(Icons.chevron_right,color: isRed? Colors.red: Colors.deepPurple,),
    );
  }
}
