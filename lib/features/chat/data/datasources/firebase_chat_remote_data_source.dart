import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/data/models/message_model.dart';
import '../../../../core/error/failure.dart';
import '../models/chat_model.dart';
import 'chat_remote_data_source.dart';

class FirebaseChatRemoteDataSource implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  FirebaseChatRemoteDataSource(this.firestore);

  @override
  Future<void> sendMessage(MessageModel message) async {
    await firestore.collection('messages').add({
      'chatId': message.groupId,
      'senderId': message.senderId,
      'senderName': message.senderName,
      'content': message.content,
      'type': message.type.toString().split('.').last, // Store type as string
      'timestamp': message.timestamp.toIso8601String(),
      'isRead': message.isRead,
    });
  }

  @override
  Future<List<MessageModel>> fetchMessages(String chatId) async {
    try {
      final querySnapshot = await firestore
          .collection('messages')
          .where('chatId', isEqualTo: chatId) // Filter by chatId
          .orderBy('timestamp', descending: false) // Order by timestamp
          .get();

      return querySnapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error in getMessages: $e");
      throw ServerFailure();
    }
  }

  @override
  Future<void> updateMessageReadStatus(String messageId, bool isRead) async {
    await firestore
        .collection('messages')
        .doc(messageId)
        .update({'isRead': isRead});
  }

  @override
  Future<void> updateUserPresence(String userId, bool isOnline) async {
    await firestore
        .collection('users')
        .doc(userId)
        .update({'isOnline': isOnline});
  }

  @override
  Stream<bool> listenToUserPresence(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc['isOnline'] as bool);
  }

  @override
  Stream<List<MessageModel>> listenToMessages(String chatId) {
    return firestore.collection('chats/$chatId/messages').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> createChat(ChatModel chat) async {
    await firestore.collection('chats').doc(chat.id).set(chat.toJson());
  }

  @override
  Future<List<ChatModel>> loadChats(String userId) async {
    final snapshot = await firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastUpdated', descending: true)
        .get();

    return snapshot.docs.map((doc) => ChatModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await firestore.collection('chats').doc(chatId).delete();
  }

  @override
  Future<List<ChatModel>> getAllChats(String userId, bool isGroup) async {
    final querySnapshot = await firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .where('isGroup', isEqualTo: isGroup)
        .orderBy('lastUpdated', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ChatModel.fromJson(doc.data()))
        .toList();
  }
}
