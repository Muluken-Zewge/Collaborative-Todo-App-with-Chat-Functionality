import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/constants.dart';
import 'domain/entities/auth_user.dart';

class CustomDrawer extends StatelessWidget {
  final AuthUser authUser;
  const CustomDrawer({super.key, required this.authUser});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignOutSuccessState) {
          Navigator.of(context).pushReplacementNamed('/signin');
        } else if (state is SignOutFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign Out Failed: ${state.failure}')),
          );
        }
      },
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        radius: 34,
                        child: Text(
                          '${authUser.displayName?.substring(0, 2)}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Text('${authUser.displayName}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ]),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded),
              title: const Text('Profile'),
              onTap: () {},
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is SignOutLoadingState) {
                  return const CircularProgressIndicator();
                }
                return ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onTap: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
