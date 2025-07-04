import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/view_models/profile_cubit/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final UserModel user;
  final Function()? onTap;
  final bool isRemovable;

  const ProfilePhotoWidget({
    super.key,
    required this.user,
    this.onTap,
    this.isRemovable = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    final bloc = BlocProvider.of<ProfileBloc>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        if(isRemovable)
        SizedBox(height: deviceSize.height*0.24,),
        CircleAvatar(
          radius:
              isRemovable ? deviceSize.width * 0.2 : deviceSize.width * 0.14,
          backgroundImage: user.profilePhotoUrl != null
              ? NetworkImage(user.profilePhotoUrl!)
              : null,
          child: user.profilePhotoUrl == null
              ? Text(
                  "${user.firstName[0]}${user.lastName[0]}",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        if (user.profilePhotoUrl == null && (!isRemovable))
          PositionedDirectional(
            bottom: -deviceSize.width * 0.015,
            start: deviceSize.width * 0.17,
            child: IconButton(
                onPressed: () {
                  bloc.add(UpdateProfilePhotoEvent());
                },
                icon: Icon(Icons.add_a_photo)),
          ),
        if (isRemovable) ...[
          PositionedDirectional(
            bottom: deviceSize.height*0.19,
            start: deviceSize.width*0.14,
            child: Container(
              height: 42,
              decoration: BoxDecoration(color: themeData.primaryColor,shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () {
                    bloc.add(UpdateProfilePhotoEvent());
                  },
                  icon: Icon(Icons.add_a_photo_outlined,color: Colors.white,)),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: deviceSize.width*0.14,
            child: IconButton(
                onPressed: () {
                  bloc.add(DeleteProfilePhotoEvent());
                },
                icon: Icon(Icons.remove_circle_sharp,color: Colors.red,size: 29,)),
          ),
        ]
      ],
    );
  }
}
