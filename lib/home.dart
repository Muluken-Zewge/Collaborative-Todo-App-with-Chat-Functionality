// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/drawer.dart';

import 'core/constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, AuthUser>?;

    final authUser = args?['authUser'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: primaryLightColor),
          title: const Text(
            'Home page',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: authUser != null
            ? CustomDrawer(authUser: authUser)
            : const Center(child: Text("User not found")),
      ),
    );
  }
}
