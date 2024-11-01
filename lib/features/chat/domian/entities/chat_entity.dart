import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id; // Unique identifier for the chat
  final bool isGroup;
  final List<String> participantIds; // List of user IDs involved in the chat
  final DateTime lastUpdated; // Timestamp of the last activity
  final String? lastMessage; // Preview of the last message sent in the chat
  final bool isArchived; // Whether the chat is archived
  final List<String> participantUserNames; // New property for user names

  const Chat({
    required this.id,
    required this.participantIds,
    required this.lastUpdated,
    required this.isGroup,
    this.lastMessage,
    this.isArchived = false,
    required this.participantUserNames,
  });

  @override
  List<Object?> get props =>
      [id, isGroup, participantIds, lastUpdated, lastMessage, isArchived];
}
