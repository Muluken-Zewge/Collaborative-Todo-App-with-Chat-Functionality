import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String userName,
  });

  /// Returns the currently authenticated user, if available.
  Future<AuthUserModel?> getCurrentUser();

  Future<void> signOut();

  Future<void> resetPassword(String email);
}
