// lib/features/chat/data/models/user_presence_model.dart

import '../../domian/entities/user_presence_entity.dart';

class UserPresenceModel extends UserPresence {
  const UserPresenceModel({
    required super.userId,
    required super.isOnline,
    super.lastActive,
  });

  // Convert JSON to UserPresenceModel
  factory UserPresenceModel.fromJson(Map<String, dynamic> json) {
    return UserPresenceModel(
      userId: json['userId'] as String,
      isOnline: json['isOnline'] as bool,
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : null,
    );
  }

  // Convert UserPresenceModel to JSON for Firebase storage
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isOnline': isOnline,
      'lastActive': lastActive?.toIso8601String(),
    };
  }
}
