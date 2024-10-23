// lib/src/presentation/auth/screens/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/background.dart';
import '../widgets/responsive.dart';
import '../widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignupScreen(),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({super.key});

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
          child: SvgPicture.asset("assets/icons/signup.svg"),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SignUpForm(), // Place the SignInForm widget here without Expanded
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signin');
                    },
                    child: const Text('Sign In'),
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
