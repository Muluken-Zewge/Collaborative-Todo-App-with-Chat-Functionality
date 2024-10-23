import 'package:dartz/dartz.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failure.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, AuthUser>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(email: email, password: password);
  }
}
