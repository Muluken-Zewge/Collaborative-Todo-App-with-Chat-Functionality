import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:collaborative_todo_app_with_chat_functionality/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  final authRemoteDataSource =
      FirebaseAuthRemoteDataSource(firebaseAuth, fireStore);

  final authRepository = AuthRepositoryImpl(authRemoteDataSource);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        SignIn(authRepository),
        SignUp(authRepository),
        SignOut(authRepository),
        GetCurrentUser(authRepository),
      )..add(AuthCheckRequested()), // Check authentication on app start
      child: MaterialApp(
        home: const AuthNavigator(),
        routes: {
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        } else if (state is Unauthenticated || state is AuthInitial) {
          return const SignInScreen();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
