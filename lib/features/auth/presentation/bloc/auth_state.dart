part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final AuthUser user;

  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class SignInLoadingState extends AuthState {}

class SignInSuccessState extends AuthState {
  final AuthUser user;

  const SignInSuccessState(this.user);
}

class SignInFailureState extends AuthState {
  final Failure failure;

  const SignInFailureState(this.failure);
}

class SignUpLoadingState extends AuthState {}

class SignUpSuccessState extends AuthState {
  final AuthUser user;

  const SignUpSuccessState(this.user);
}

class SignUpFailureState extends AuthState {
  final Failure failure;

  const SignUpFailureState(this.failure);
}

class SignOutLoadingState extends AuthState {}

class SignOutSuccessState extends AuthState {}

class SignOutFailureState extends AuthState {
  final Failure failure;

  const SignOutFailureState(this.failure);
}
