import "package:e_commerce/utils/app_routes.dart";
import "package:e_commerce/view_models/auth_cubit/auth_cubit.dart";
import "package:e_commerce/views/widgets/main_button.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Verification"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification email have been sent to your E-mail, Please click the link there 📩",
                style: themeData.textTheme.titleLarge,
              ),
              SizedBox(height: 20),
              BlocConsumer<AuthCubit, AuthState>(
                bloc: authCubit,
                listenWhen: (previous, current) =>
                    current is EmailVerified ||
                    current is EmailVerificationError,
                listener: (context, state) {
                  if (state is EmailVerified) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.bottomNavbar,
                      (route) => false,
                    );
                  } else if (state is EmailVerificationError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is EmailVerifying ||
                    current is EmailVerificationError,
                builder: (context, state) {
                  if (state is EmailVerifying) {
                    return MainButton(onPressed: () {});
                  }
                  return MainButton(
                    onPressed: authCubit.checkEmailVerification,
                    text: "I have verified my e-mail",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
