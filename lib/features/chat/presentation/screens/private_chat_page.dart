import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/constants/constants.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domian/entities/chat_entity.dart';
import '../widgets/Private_chat_detail_page.dart';

class PrivateChatPage extends StatefulWidget {
  final AuthUser authUser;
  const PrivateChatPage({super.key, required this.authUser});

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d').format(dateTime);
  }

  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChats(widget.authUser.id, false));
  }

  void _searchUsers(String query) async {
    if (query.isEmpty) return;

    final results = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: "$query\uf8ff")
        .get();

    setState(() {
      _searchResults = results.docs.map((doc) {
        return {
          'userId': doc.id,
          'email': doc['email'],
          'userName': doc['userName'],
        };
      }).toList();
    });
  }

  void _showSearchModal() {
    _searchController.clear();
    _searchResults.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search a user by email',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _searchUsers,
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user['userName']?.substring(0, 2) ?? ""),
                      ),
                      title: Text(user['userName'] ?? ""),
                      subtitle: Text(user['email'] ?? ""),
                      onTap: () {
                        final newChat = Chat(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          isGroup: false,
                          participantIds: [widget.authUser.id, user['userId']],
                          participantUserNames: [
                            widget.authUser.displayName ?? '',
                            user['userName']
                          ],
                          lastUpdated: DateTime.now(),
                          lastMessage: '',
                          isArchived: false,
                        );
                        context.read<ChatBloc>().add(CreateChat(newChat));
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatCreated) {
            final recipientUserName =
                state.chat.participantUserNames.firstWhere(
              (name) => name != widget.authUser.displayName,
              orElse: () => 'Unknown',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivateChatDetailPage(
                  chatId: state.chat.id,
                  authUser: widget.authUser,
                  recipientUserName: recipientUserName,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            final privateChats =
                state.chats.where((chat) => !chat.isGroup).toList();
            return privateChats.isEmpty
                ? const Center(child: Text('No private chats available'))
                : ListView.builder(
                    itemCount: privateChats.length,
                    itemBuilder: (context, index) {
                      final chat = privateChats[index];
                      final lastMessage = chat.lastMessage ?? 'No messages yet';
                      final time = _formatDateTime(chat.lastUpdated);

                      final recipientUserName =
                          chat.participantUserNames.firstWhere(
                        (name) => name != widget.authUser.displayName,
                        orElse: () => 'Unknown',
                      );

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivateChatDetailPage(
                                      chatId: chat.id,
                                      authUser: widget.authUser,
                                      recipientUserName: recipientUserName)));
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Colors.primaries[index % Colors.primaries.length],
                          child: Text(
                            chat.participantUserNames.first.substring(0, 2),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          chat.participantUserNames[1],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          lastMessage,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: Text(time),
                      );
                    },
                  );
          } else {
            return const Center(child: Text('Error loading chats.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        heroTag: 'privateChatFAB',
        onPressed: _showSearchModal,
        child: const Icon(Icons.add, color: primaryLightColor),
      ),
    );
  }
}
