part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});

  // @override
  // List<Object?> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String userName;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.userName,
  });
}

class SignOutEvent extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
