// reset_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../bloc/auth_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset link sent!')),
              );
              Navigator.of(context).pushReplacementNamed('/signin');
            } else if (state is ResetPasswordFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your email to receive a password reset link:',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.email),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                            ResetPasswordEvent(
                                email: _emailController.text.trim()),
                          );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Send Reset Link',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
