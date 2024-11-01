import 'package:equatable/equatable.dart';

class UserPresence extends Equatable {
  final String userId;
  final bool isOnline;
  final DateTime? lastActive;

  const UserPresence({
    required this.userId,
    required this.isOnline,
    this.lastActive,
  });

  @override
  List<Object?> get props => [userId, isOnline, lastActive];
}
