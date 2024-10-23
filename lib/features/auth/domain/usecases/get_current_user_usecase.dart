import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_user.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Option<AuthUser>> call() async {
    return await repository.getCurrentUser();
  }
}
