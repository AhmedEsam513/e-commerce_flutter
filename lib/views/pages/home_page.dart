import 'package:e_commerce/view_models/home_tab_cubit/home_tab_cubit.dart';
import 'package:e_commerce/views/widgets/category_tab_view.dart';
import 'package:e_commerce/views/widgets/home_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight:
              isPortrait ? deviceSize.height * 0.1 : deviceSize.height * 0.2,
          backgroundColor: Colors.white,
          title: BlocBuilder<HomeTabCubit, HomeTabState>(
            bloc: BlocProvider.of<HomeTabCubit>(context),
            buildWhen: (previous, current) =>
                current is HomeTabLoaded ||
                current is HomeTabError ||
                current is HomeTabLoading,
            builder: (context, state) {
              if (state is HomeTabLoading) {
                return CircularProgressIndicator();
              } else if (state is HomeTabLoaded) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: state.user.profilePhotoUrl != null
                          ? NetworkImage(state.user.profilePhotoUrl!)
                          : null,
                      child: state.user.profilePhotoUrl == null
                          ? Text(
                              "${state.user.firstName[0]}${state.user.lastName[0]}")
                          : null,
                    ),
                    SizedBox(width: deviceSize.width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${state.user.firstName} ${state.user.lastName}",
                          style: themeData.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Let's Go Shoppping",
                          style: themeData.textTheme.labelMedium!.copyWith(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is HomeTabError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: SizedBox.shrink());
              }
            },
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          ],
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: "Home",
              ),
              Tab(
                text: "Category",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTabView(),
            CategoryTabView(),
          ],
        ),
      ),
    );
  }
}
