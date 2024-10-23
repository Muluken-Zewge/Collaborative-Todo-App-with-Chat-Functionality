import 'package:dartz/dartz.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failure.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, AuthUser>> call({
    required String email,
    required String password,
    required String userName,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      userName: userName,
    );
  }
}
