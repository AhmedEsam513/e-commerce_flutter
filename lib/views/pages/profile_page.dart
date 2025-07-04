import 'dart:ffi';

import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/auth_cubit/auth_cubit.dart';
import 'package:e_commerce/view_models/profile_cubit/profile_bloc.dart';
import 'package:e_commerce/views/widgets/profile_list_tile.dart';
import 'package:e_commerce/views/widgets/profile_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    final profileBloc = BlocProvider.of<ProfileBloc>(context);

    late UserModel user;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: deviceSize.width * 0.04,
                vertical: deviceSize.height * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Profile",
                  style: themeData.textTheme.headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: deviceSize.height * 0.04),
                Row(
                  children: [
                    BlocConsumer<ProfileBloc, ProfileState>(
                        buildWhen: (previous, current) =>
                            current is ProfileLoaded ||
                            current is ProfilePhotoLoaded ||
                            current is ProfilePhotoLoading ||
                            current is ProfileLoading,
                        builder: (context, state) {
                          if (state is ProfileLoaded) {
                            user = state.userData;
                            return ProfilePhotoWidget(
                              user: state.userData,
                            );
                          } else if (state is ProfilePhotoLoaded) {
                            user = state.userData;
                            return ProfilePhotoWidget(
                              user: state.userData,
                            );
                          } else {
                            return CircleAvatar(
                              radius: deviceSize.width * 0.14,
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        listenWhen: (previous, current) =>
                            current is ProfilePhotoError,
                        listener: (context, state) {
                          if (state is ProfilePhotoError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                              ),
                            );
                          }
                        }),
                    SizedBox(width: deviceSize.width * 0.025),
                    BlocConsumer<ProfileBloc, ProfileState>(
                      bloc: profileBloc,
                      buildWhen: (previous, current) =>
                          current is ProfileLoaded || current is ProfileLoading,
                      builder: (context, state) {
                        if (state is ProfileLoaded) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${state.userData.firstName} ${state.userData.lastName}",
                                style: themeData.textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                state.userData.email,
                                style: themeData.textTheme.titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              SizedBox(width: deviceSize.width * 0.25),
                              CircularProgressIndicator(),
                            ],
                          );
                        }
                      },
                      listenWhen: (current, previous) =>
                          current is ProfileError,
                      listener: (context, state) {
                        if (state is ProfileError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed : ${state.message}"),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: deviceSize.height * 0.05),
                ProfileListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.editProfile,
                        arguments: {
                          "bloc": profileBloc,
                          "userData": user
                        }).then((value) {
                      profileBloc.add(FetchProfileEvent());
                    });
                  },
                  title: "Edit Profile",
                  icon: Icons.edit_outlined,
                  //subTitle: "Photo, Name, Email",
                ),
                Divider(thickness: 1),
                ProfileListTile(
                  onTap: () {},
                  title: "My Orders",
                  icon: Icons.shopping_bag_outlined,
                ),
                Divider(thickness: 1),
                ProfileListTile(
                  onTap: () {},
                  title: "Payment Methods",
                  icon: Icons.credit_card_outlined,
                ),
                Divider(thickness: 1),
                ProfileListTile(
                  onTap: () {},
                  title: "Shipping Addresses",
                  icon: Icons.local_shipping_outlined,
                ),
                Divider(thickness: 1),

//<<< Log Out >>>
                BlocConsumer<ProfileBloc, ProfileState>(
                  bloc: profileBloc,
                  listenWhen: (previous, current) =>
                      current is LoggedOut || current is LogOutError,
                  listener: (context, state) {
                    if (state is LoggedOut) {
                      debugPrint("i will navigate to login page");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.logIn,
                        (route) => false,
                      );
                      debugPrint("i navigated to login page");
                    } else if (state is LogOutError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed : ${state.message}"),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        ProfileListTile(
                          onTap: () {
                            profileBloc.add(LogOutEvent());
                          },
                          title: "Log Out",
                          icon: Icons.logout_outlined,
                          isRed: true,
                        ),
                        Divider(thickness: 1),
                        ProfileListTile(
                          onTap: () {
                            profileBloc.add(DeleteUserEvent());
                          },
                          title: "Delete Account",
                          icon: Icons.delete,
                          isRed: true,
                        ),
                      ],
                    );
                  },
                ),
                Divider(thickness: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
