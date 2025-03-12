import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/auth_cubit/auth_cubit.dart';
import 'package:e_commerce/views/widgets/profile_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    final authCubit = BlocProvider.of<AuthCubit>(context);
    authCubit.getUser();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: deviceSize.width * 0.05,
                vertical: deviceSize.height * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Profile",
                  style: themeData.textTheme.headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: deviceSize.height * 0.04),
                SizedBox(width: deviceSize.width * 0.04),
                BlocBuilder<AuthCubit, AuthState>(
                  bloc: authCubit,
                  buildWhen: (previous, current) => current is AuthLoaded,
                  builder: (context, state) {
                    if (state is AuthLoaded) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child:  Text(
                              "${state.userData.firstName[0]}${state.userData.lastName[0]}",
                              style: themeData.textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: deviceSize.width * 0.03),
                          Column(
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
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text("Something went wrong"));
                    }
                  },
                ),
                SizedBox(height: deviceSize.height * 0.05),
                ProfileListTile(
                  onTap: () {},
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
                BlocConsumer<AuthCubit, AuthState>(
                  bloc: authCubit,
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
                          content: Text("Failed"),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        ProfileListTile(
                          onTap: authCubit.logOut,
                          title: "Log Out",
                          icon: Icons.logout_outlined,
                          isRed: true,
                        ),
                        Divider(thickness: 1),
                        ProfileListTile(
                          onTap: authCubit.deleteUser,
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
