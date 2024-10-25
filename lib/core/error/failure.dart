import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class AccountExisted extends Failure {
  @override
  List<Object?> get props => [];
}

class InCorrectCredential extends Failure {
  @override
  List<Object?> get props => [];
}

class TooManyRequestsFailure extends Failure {
  @override
  List<Object?> get props => throw UnimplementedError();
}
