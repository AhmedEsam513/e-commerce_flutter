import 'package:e_commerce/services/hive_services.dart';
import 'package:e_commerce/utils/app_router.dart';
import 'package:e_commerce/view_models/auth_cubit/auth_cubit.dart';
import 'package:e_commerce/views/pages/bottom_navbar.dart';
import 'package:e_commerce/views/pages/loading_page.dart';
import 'package:e_commerce/views/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveServices.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final mainCubit = AuthCubit();
        mainCubit.getUser();
        return mainCubit;
      },
      child: Builder(builder: (context) {
        return BlocBuilder<AuthCubit, AuthState>(
          bloc: BlocProvider.of<AuthCubit>(context),
          buildWhen: (previous, current) =>
              current is AuthLoaded ||
              current is AuthError ||
              current is AuthLoading ||
              current is NoUserFoundState,
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'E-commerce App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              //home: const BottomNavbar(),
              //initialRoute: AppRoutes.logIn,
              home: state is AuthLoaded
                  ? BottomNavbar()
                  : state is AuthLoading
                      ? LoadingPage()
                      : LoginPage(),
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        );
      }),
    );
  }
}
