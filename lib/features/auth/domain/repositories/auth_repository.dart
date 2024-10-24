import 'package:dartz/dartz.dart';

import '../entities/auth_user.dart';
import '../../../../core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
    required String userName,
  });

  Future<Option<AuthUser>> getCurrentUser();

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> resetPassword(String email);
}
