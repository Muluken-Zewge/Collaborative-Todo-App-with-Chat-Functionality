import 'package:dartz/dartz.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';
import '../../../../core/error/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthUserModel user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(user); // Return the AuthUserModel as AuthUser
    } catch (e) {
      if (e.toString().contains('network error')) {
        return Left(OfflineFailure());
      } else if (e.toString().contains('auth credential is incorrect')) {
        return Left(InCorrectCredential());
      } else {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      final AuthUserModel user = await remoteDataSource.signUp(
        email: email,
        password: password,
        userName: userName,
      );
      return Right(user); // Return the AuthUserModel as AuthUser
    } catch (e) {
      if (e.toString().contains('email-already-in-use')) {
        return Left(AccountExisted());
      } else if (e.toString().contains('network error')) {
        return Left(OfflineFailure());
      } else {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Option<AuthUser>> getCurrentUser() async {
    try {
      final AuthUserModel? user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        return Some(user); // Return the current AuthUser if logged in
      } else {
        return const None(); // No user is logged in
      }
    } catch (e) {
      return const None();
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(unit); // Return success with no value
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await remoteDataSource
          .resetPassword(email); // Call the remote data source method
      return const Right(unit); // Return success (Right) with no value
    } catch (e) {
      return Left(ServerFailure()); // Return failure (Left) if any error occurs
    }
  }
}
