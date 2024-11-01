import 'package:collaborative_todo_app_with_chat_functionality/core/constants/constants.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GroupChatPage extends StatefulWidget {
  final AuthUser authUser;
  const GroupChatPage({super.key, required this.authUser});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChats(widget.authUser.id, true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            final groupChats =
                state.chats.where((chat) => chat.isGroup).toList();
            return groupChats.isEmpty
                ? const Center(child: Text('No group chats available'))
                : ListView.builder(
                    itemCount: groupChats.length,
                    itemBuilder: (context, index) {
                      final chat = groupChats[index];
                      final lastMessage = chat.lastMessage ?? 'No messages yet';
                      final time = _formatDateTime(chat.lastUpdated);

                      return ListTile(
                        onTap: () {
                          // Navigate to group chat details page
                        },
                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.primaries[index % Colors.primaries.length],
                          child: Text(
                            chat.participantIds.first
                                .substring(0, 2)
                                .toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          chat.participantIds.join(', '),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              '${chat.participantIds.first}: ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                lastMessage,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(time),
                      );
                    },
                  );
          } else {
            return const Center(child: Text('Error loading group chats.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        heroTag: 'groupChatFAB',
        onPressed: () {
          // Add group chat functionality
        },
        child: const Icon(Icons.add, color: primaryLightColor),
      ),
    );
  }
}
