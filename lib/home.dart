import 'package:collaborative_todo_app_with_chat_functionality/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';

import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/constants.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'features/todo/presentation/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Safely access context here
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, AuthUser>?;
    final authUser = args?['authUser'];

    if (authUser != null) {
      context.read<TodoBloc>().add(LoadTodos(authUser.id));
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
            'CollabHub',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: authUser != null
            ? CustomDrawer(authUser: authUser)
            : const Center(child: Text("User not found")),

        // Loads tasks for the current user
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            authUser != null
                ? TodoScreen(authUser: authUser)
                : const Center(child: Text("User not found")),
            authUser != null
                ? ChatScreen(authUser: authUser)
                : const Center(child: Text("User not found")),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box),
              label: 'Todo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
