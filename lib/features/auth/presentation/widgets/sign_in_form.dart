import 'package:collaborative_todo_app_with_chat_functionality/core/constants/constants.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/bloc/auth_bloc.dart';
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
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignInSuccessState) {
          Navigator.of(context).pushReplacementNamed('/home',
              arguments: {'authUser': state.user});
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.email)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock)),
                suffixIcon: IconButton(
                    onPressed: () => setState(() {
                          _isObscure = !_isObscure;
                        }),
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  Navigator.of(context).pushNamed('/reset-password');
                },
                child: const Text('Forgot Password?'),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is SignInLoadingState) {
                  return const Center(child: CircularProgressIndicator());
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
