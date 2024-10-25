import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/widgets/background.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Stack(children: [
            const Background(
              child: SingleChildScrollView(
                child: Responsive(
                  mobile: MobileLoginScreen(),
                ),
              ),
            ),
            if (state is SignInLoadingState)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
          ]);
        },
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 8,
              fit: FlexFit.loose,
              child: SvgPicture.asset("assets/icons/login.svg"),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SignInForm(),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/signup');
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
