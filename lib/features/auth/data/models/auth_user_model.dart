import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.userName,
    super.displayName,
  });

  /// Convert Firebase user to AuthUserModel
  factory AuthUserModel.fromFirebaseUser(user) {
    return AuthUserModel(
      id: user.uid,
      email: user.email,
      userName: user.userName ?? '',
      displayName: user.displayName,
    );
  }

  /// Convert Firestore Document to AuthUserModel (for advanced user handling)
  factory AuthUserModel.fromDocument(Map<String, dynamic> doc, String uid) {
    return AuthUserModel(
      id: uid,
      email: doc['email'] as String,
      userName: doc['userName'] as String,
      displayName: doc['displayName'] as String?,
    );
  }

  /// Convert AuthUserModel to JSON (for saving user data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'displayName': displayName,
    };
  }
}
