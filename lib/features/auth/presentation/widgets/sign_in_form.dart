import 'package:collaborative_todo_app_with_chat_functionality/core/constants/constants.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:collaborative_todo_app_with_chat_functionality/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignInFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign In Failed: ${state.failure}')),
          );
        } else if (state is SignInSuccessState) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.email)),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock)),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is SignInLoadingState) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(SignInEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ));
                    }
                  },
                  child: const Text('Sign In'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
