import 'package:bloc/bloc.dart';
import 'package:collaborative_todo_app_with_chat_functionality/core/error/failure.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/entities/auth_user.dart';
import 'package:collaborative_todo_app_with_chat_functionality/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUser;
  final ResetPassword resetPassword;

  AuthBloc(this.signIn, this.signUp, this.signOutUseCase, this.getCurrentUser,
      this.resetPassword)
      : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(SignInLoadingState());
      final Either<Failure, AuthUser> result = await signIn(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(SignInFailureState(failure)),
        (user) => emit(SignInSuccessState(user)),
      );
    });

    on<SignUpEvent>((event, emit) async {
      emit(SignUpLoadingState());
      final Either<Failure, AuthUser> result = await signUp(
        email: event.email,
        password: event.password,
        userName: event.userName,
      );
      result.fold((failure) {
        emit(SignUpFailureState(failure));
      }, (user) {
        emit(SignUpSuccessState(user));
      });
    });

    on<SignOutEvent>((event, emit) async {
      emit(SignOutLoadingState());
      final Either<Failure, Unit> result = await signOutUseCase();
      result.fold(
        (failure) => emit(SignOutFailureState(failure)),
        (_) => emit(SignOutSuccessState()),
      );
    });

    on<AuthCheckRequested>((event, emit) async {
      final Option<AuthUser> userOption = await getCurrentUser();
      userOption.fold(
        () => emit(Unauthenticated()), // No user found, emit Unauthenticated
        (user) => emit(Authenticated(user)), // User found, emit Authenticated
      );
    });

    on<ResetPasswordEvent>((event, emit) async {
      final Either<Failure, Unit> result = await resetPassword(event.email);

      result.fold(
        (failure) => emit(const ResetPasswordFailureState(
            'Failed to send reset password link')),
        (_) => emit(ResetPasswordSuccessState()),
      );
    });
  }
}
