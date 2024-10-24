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
      if (e.toString().contains('network')) {
        return Left(OfflineFailure());
      } else if (e.toString().contains('wrong-password')) {
        return Left(WrongPasswordFailure());
      } else if (e.toString().contains('user-not-found')) {
        return Left(NoUserFailure());
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
      print("Repository: Attempting sign-up with email $email");
      final AuthUserModel user = await remoteDataSource.signUp(
        email: email,
        password: password,
        userName: userName,
      );
      print("Repository: Sign-up successful");
      return Right(user); // Return the AuthUserModel as AuthUser
    } catch (e) {
      print("Repository: Sign-up failed with error $e");
      if (e.toString().contains('email-already-in-use')) {
        return Left(ExistedAccountFailure());
      } else {
        print(e.toString());
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
}
