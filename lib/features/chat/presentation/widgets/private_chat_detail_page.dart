import 'package:collaborative_todo_app_with_chat_functionality/core/constants/constants.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/message_model.dart';
import '../../domian/entities/message_entity.dart';

class PrivateChatDetailPage extends StatefulWidget {
  final String chatId;
  final AuthUser authUser;
  final String recipientUserName;

  const PrivateChatDetailPage({
    super.key,
    required this.chatId,
    required this.authUser,
    required this.recipientUserName,
  });

  @override
  State<PrivateChatDetailPage> createState() => _PrivateChatDetailPageState();
}

class _PrivateChatDetailPageState extends State<PrivateChatDetailPage> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchMessagesEvent(widget.chatId));
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: widget.authUser.id,
        senderName: widget.authUser.displayName ?? '',
        content: content,
        type: MessageType.text,
        timestamp: DateTime.now(),
        isRead: false,
        groupId: widget.chatId,
      );

      context.read<ChatBloc>().add(SendMessageEvent(message, widget.chatId));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          context.read<ChatBloc>().add(LoadChats(widget.authUser.id, false));
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: primaryColor,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircleAvatar(
                  radius: 25,
                  child: Text(widget.recipientUserName.substring(0, 2)),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.recipientUserName,
                  style: const TextStyle(color: Colors.white),
                )
              ]),
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is MessageLoaded) {
                        if (state.messages.isEmpty) {
                          return const Center(
                              child: Text("Start a conversation"));
                        }
                        return ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            final isSentByUser =
                                message.senderId == widget.authUser.id;
                            return Align(
                              alignment: isSentByUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSentByUser
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.content,
                                      style: TextStyle(
                                          color: isSentByUser
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    Text(
                                      DateFormat('MMM d, h:mm a')
                                          .format(message.timestamp.toLocal()),
                                      style: TextStyle(
                                        color: isSentByUser
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is MessageLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatError) {
                        return const Center(
                            child: Text("Error occured fetching message"));
                      } else {
                        return const Center(
                            child: Text('dont know what happened man'));
                      }
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage),
                      IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {
                          // Implement audio message feature
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: () {
                          // Implement image message feature
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
