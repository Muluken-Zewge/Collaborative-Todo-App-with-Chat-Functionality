import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

//import '../bloc/chat_bloc.dart';
import '../bloc/chat_bloc.dart';
import 'gropu_chat_page.dart';
import 'private_chat_page.dart';

class ChatScreen extends StatefulWidget {
  final AuthUser authUser;
  const ChatScreen({super.key, required this.authUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChats(widget.authUser.id, false));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.blue,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'Private Chats'),
                Tab(text: 'Group Chats'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PrivateChatPage(authUser: widget.authUser),
                  GroupChatPage(authUser: widget.authUser),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
