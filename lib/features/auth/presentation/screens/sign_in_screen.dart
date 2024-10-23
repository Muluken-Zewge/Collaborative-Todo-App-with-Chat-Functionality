// lib/src/presentation/auth/screens/sign_in_screen.dart

import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/widgets/background.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileLoginScreen(),
        ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // Set the main axis size to minimum
      children: <Widget>[
        // Use Flexible instead of Expanded to avoid layout issues
        Flexible(
          flex: 8,
          fit: FlexFit.loose, // Use FlexFit.loose to avoid over-expanding
          child: SvgPicture.asset("assets/icons/login.svg"),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SignInForm(), // Place the SignInForm widget here without Expanded
              const SizedBox(height: 20),
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
    );
  }
}
