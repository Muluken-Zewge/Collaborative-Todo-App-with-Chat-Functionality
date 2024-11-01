import '../../domian/entities/chat_entity.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.isGroup,
    required super.participantIds,
    required super.lastUpdated,
    super.lastMessage,
    super.isArchived,
    required super.participantUserNames,
  });

  /// Converts a Chat entity into a ChatModel instance
  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      isGroup: chat.isGroup,
      participantIds: chat.participantIds,
      lastUpdated: chat.lastUpdated,
      lastMessage: chat.lastMessage,
      isArchived: chat.isArchived,
      participantUserNames: chat.participantUserNames,
    );
  }

  /// Converts JSON data into a ChatModel instance
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      isGroup: json['isGroup'] as bool,
      participantIds: List<String>.from(json['participantIds']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      lastMessage: json['lastMessage'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
      participantUserNames: List<String>.from(json['participantUserNames']),
    );
  }

  /// Converts the ChatModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isGroup': isGroup == false ? false : true,
      'participantIds': participantIds,
      'lastUpdated': lastUpdated.toIso8601String(),
      'lastMessage': lastMessage,
      'isArchived': isArchived,
      'participantUserNames': participantUserNames
    };
  }

  /// Converts ChatModel back to a Chat entity
  Chat toEntity() {
    return Chat(
        id: id,
        isGroup: isGroup,
        participantIds: participantIds,
        lastUpdated: lastUpdated,
        lastMessage: lastMessage,
        isArchived: isArchived,
        participantUserNames: participantUserNames);
  }
}
