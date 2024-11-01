import '../../domian/entities/message_entity.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.content,
    required super.type,
    required super.timestamp,
    super.isRead,
    super.groupId,
  });

  /// Factory constructor to create a `MessageModel` from JSON data.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '', // Provide a default empty string
      senderId: json['senderId'] as String? ?? '',
      senderName:
          json['senderName'] as String? ?? 'Unknown', // Default to 'Unknown'
      content: json['content'] as String? ?? '',
      type: _parseMessageType(
          json['type']), // Updated to handle enum parsing safely
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      groupId: json['groupId'] as String?,
    );
  }

  /// Convert a `MessageModel` into JSON for Firebase storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'type': type.index, // Store enum as an integer
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'groupId': groupId,
    };
  }

  /// Helper method to parse `type` safely.
  static MessageType _parseMessageType(dynamic type) {
    if (type is int && type >= 0 && type < MessageType.values.length) {
      return MessageType.values[type];
    }
    return MessageType.text; // Default to text if type is unknown or invalid
  }

  /// Factory constructor to create a `MessageModel` from a `Message` entity.
  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      senderId: message.senderId,
      senderName: message.senderName,
      content: message.content,
      type: message.type,
      timestamp: message.timestamp,
      isRead: message.isRead,
      groupId: message.groupId,
    );
  }

  /// Convert `MessageModel` back to a `Message` entity.
  Message toEntity() {
    return Message(
      id: id,
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: type,
      timestamp: timestamp,
      isRead: isRead,
      groupId: groupId,
    );
  }
}
