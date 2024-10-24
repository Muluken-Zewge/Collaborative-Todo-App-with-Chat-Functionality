import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRemoteDataSource(this._firebaseAuth, this._firestore);

  @override
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        throw Exception('User data not found in Firestore');
      }
      return AuthUserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? email,
          userName: userDoc.data()?['userName'] ?? '',
          displayName: userCredential.user!.displayName ?? '');
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  @override
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save the user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'userName': userName,
        'displayName': userName,
      });
      // Update the Firebase user's display name
      await userCredential.user!.updateDisplayName(userName);

      return AuthUserModel(
          id: userCredential.user!.uid,
          email: email,
          userName: userName,
          displayName: userName);
    } catch (e) {
      throw Exception('Error signing up: $e');
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return AuthUserModel.fromFirebaseUser(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
          email: email); // Send password reset email
    } catch (e) {
      throw Exception(
          'Failed to send reset password email: $e'); // Throw error if sending fails
    }
  }
}
