import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/domian/usecases/create_chat_usecase.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/chat/data/datasources/firebase_chat_remote_data_source.dart';
import 'features/chat/domian/usecases/fetch_message_usecase.dart';
import 'features/chat/domian/usecases/get_all_chats_usecase.dart';
import 'features/chat/domian/usecases/listen_to_message_usecase.dart';
import 'features/chat/domian/usecases/listen_to_user_presence_usecase.dart';
import 'features/chat/domian/usecases/send_message_usecase.dart';
import 'features/chat/domian/usecases/set_user_presence_usecase.dart';
import 'features/chat/domian/usecases/update_message_read_status_usecase.dart';
import 'features/todo/data/datasource/firebase_task_remote_data_source.dart';
import 'features/todo/data/repositories/task_repository_impl.dart';
import 'features/todo/domain/usecases/add_task_usecase.dart';
import 'features/todo/domain/usecases/delete_task_usecase.dart';
import 'features/todo/domain/usecases/edit_task_usecase.dart';
import 'features/todo/domain/usecases/get_all_tasks.dart';
import 'features/todo/domain/usecases/mark_as_notified_usecase.dart';
import 'features/todo/domain/usecases/pin_task_usecase.dart';
import 'features/todo/domain/usecases/set_color_code_usecase.dart';
import 'features/todo/domain/usecases/set_due_date_usecase.dart';
import 'features/todo/domain/usecases/set_reminder_usecase.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  final authRemoteDataSource =
      FirebaseAuthRemoteDataSource(firebaseAuth, fireStore);
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);

  final taskRemoteDataSource = FirebaseTaskRemoteDataSource(fireStore);
  final taskRepository = TaskRepositoryImpl(taskRemoteDataSource);

  final chatRemoteDataSource = FirebaseChatRemoteDataSource(fireStore);
  final chatRepository =
      ChatRepositoryImpl(remoteDataSource: chatRemoteDataSource);

  final getAllChats = GetAllChats(chatRepository);
  final createChatUsecase = CreateChatUsecase(chatRepository);

  runApp(MyApp(
    authRepository: authRepository,
    taskRepository: taskRepository,
    chatRepository: chatRepository,
    getAllChats: getAllChats,
    createChatUsecase: createChatUsecase, // Add this to pass to ChatBloc
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final TaskRepositoryImpl taskRepository;
  final ChatRepositoryImpl chatRepository;
  final GetAllChats getAllChats; // Add GetAllChats as a parameter
  final CreateChatUsecase createChatUsecase;
  const MyApp({
    super.key,
    required this.authRepository,
    required this.taskRepository,
    required this.chatRepository,
    required this.getAllChats,
    required this.createChatUsecase, // Initialize here
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            SignIn(authRepository),
            SignUp(authRepository),
            SignOut(authRepository),
            GetCurrentUser(authRepository),
            ResetPassword(authRepository),
          )..add(AuthCheckRequested()), // Start with auth check
        ),
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(
            addTask: AddTask(taskRepository),
            editTask: EditTask(taskRepository),
            deleteTask: DeleteTask(taskRepository),
            getAllTasks: GetAllTasks(taskRepository),
            pinTask: PinTask(taskRepository),
            setColorCode: SetColorCode(taskRepository),
            setDueDate: SetDueDate(taskRepository),
            setReminder: SetReminder(taskRepository),
            markAsNotified: MarkAsNotified(taskRepository),
          ),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            SendMessage(chatRepository),
            GetAllChats(chatRepository),
            FetchMessages(chatRepository),
            ListenToMessages(chatRepository),
            SetUserPresence(chatRepository),
            ListenToUserPresence(chatRepository),
            UpdateMessageReadStatus(chatRepository),
            CreateChatUsecase(chatRepository),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthNavigator(),
        routes: {
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/reset-password': (context) => const ResetPasswordPage(),
        },
      ),
    );
  }
}

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignInFailureState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign In Failed: ${state.failure}')),
            );
          });
        }
      },
      builder: (context, state) {
        if (state is Authenticated || state is SignInSuccessState) {
          return const HomeScreen();
        } else if (state is Unauthenticated || state is AuthInitial) {
          return const SignInScreen();
        }
        return const SignInScreen();
      },
    );
  }
}
