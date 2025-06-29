import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/utils/app_routes.dart';
import 'package:e_commerce/view_models/auth_cubit/auth_cubit.dart';
import 'package:e_commerce/view_models/auth_cubit/auth_cubit.dart';
import 'package:e_commerce/views/widgets/custom_text_field_widget.dart';
import 'package:e_commerce/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_validator/string_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _logInFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: deviceSize.height * 0.04),
                Text(
                  "Login Account",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Please login with registered account",
                  style: themeData.textTheme.titleMedium!
                      .copyWith(color: Colors.grey),
                ),
                SizedBox(height: deviceSize.height * 0.05),
                Form(
                  key: _logInFormKey,
                  child: Column(
                    children: [
                      CustomTextFieldWidget(
                        controller: _emailController,
                        heading: "Email",
                        hint: "Enter your Email",
                        validator: (userInput) {
                          if (userInput == null || userInput.isEmpty) {
                            return "Please Enter Your Email";
                          } else if (!userInput.isEmail) {
                            return "Invalid Email";
                          } else {
                            return null;
                          }
                        },
                        prefixIcon: Icons.email_outlined,
                      ),
                      CustomTextFieldWidget(
                        controller: _passwordController,
                        heading: "Password",
                        hint: "Enter your Password",
                        validator: (userInput) {
                          if (userInput == null || userInput.isEmpty) {
                            return "Please Enter Your Password";
                          } else if (userInput.length < 8) {
                            return "Password must be at least 8 characters";
                          } else {
                            return null;
                          }
                        },
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: themeData.textTheme.titleMedium!
                          .copyWith(color: Colors.deepPurple),
                    ),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                BlocConsumer<AuthCubit, AuthState>(
                  bloc: authCubit,
                  listenWhen: (previous, current) =>
                      current is AuthLoaded || current is AuthError,
                  listener: (context, state) {
                    if (state is AuthLoaded) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.bottomNavbar, (route) => false);
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is AuthLoading ||
                      current is AuthError ||
                      current is AuthLoaded,
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return MainButton(onPressed: () {});
                    }

                    return MainButton(
                      onPressed: () {
                        if (_logInFormKey.currentState!.validate()) {
                          authCubit.logIn(
                              _emailController.text, _passwordController.text);
                        }
                      },
                      text: "Log In",
                    );
                  },
                ),
                SizedBox(height: deviceSize.height * 0.005),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.signUp);
                    },
                    child: Text(
                      "Create New Account",
                      style: themeData.textTheme.titleMedium!
                          .copyWith(color: Colors.deepPurple),
                    ),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    "Or using another method",
                    style: themeData.textTheme.titleMedium!
                        .copyWith(color: Colors.grey),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.01),
                anotherMethodWidget("assets/images/google.png",
                    "Sign In with Google", deviceSize, themeData),
                SizedBox(height: deviceSize.height * 0.02),
                anotherMethodWidget("assets/images/facebook.png",
                    "Sign In with Facebook", deviceSize, themeData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget anotherMethodWidget(
      String imgPath, String title, Size deviceSize, ThemeData themeData) {
    return Container(
      height: deviceSize.height * 0.07,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imgPath,
            height: deviceSize.height * 0.04,
          ),
          SizedBox(width: deviceSize.width * 0.03),
          Text(
            title,
            style: themeData.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
