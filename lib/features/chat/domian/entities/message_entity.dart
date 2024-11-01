import 'package:equatable/equatable.dart';

enum MessageType { text, image, audio }

class Message extends Equatable {
  final String id; // Unique identifier for the message
  final String senderId; // ID of the user who sent the message
  final String senderName; // Name of the user (for display purposes)
  final String content; // Text content of the message
  final MessageType type; // Type of message (text, image, or audio)
  final DateTime timestamp; // When the message was sent
  final bool isRead; // Whether the message has been read or not
  final String? groupId; // Optional group ID for group messages

  const Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.groupId,
  });

  @override
  List<Object?> get props =>
      [id, senderId, content, type, timestamp, isRead, groupId];
}
