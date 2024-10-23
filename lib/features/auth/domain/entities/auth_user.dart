import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String userName;
  final String? displayName;

  const AuthUser(
      {required this.id,
      required this.email,
      required this.userName,
      this.displayName});
  @override
  List<Object?> get props => [id, email, userName, displayName];
}
