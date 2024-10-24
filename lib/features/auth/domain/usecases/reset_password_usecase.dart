// reset_password_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, Unit>> call(String email) async {
    return await repository.resetPassword(email);
  }
}
