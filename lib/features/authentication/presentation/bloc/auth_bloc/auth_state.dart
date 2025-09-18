part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoginLoading extends AuthState {}
class AuthSignUpLoading extends AuthState {}
class AuthForgotPasswordLoading extends AuthState {}
class AuthSignInWithGoogleLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;

  const AuthAuthenticated(this.userId);

  @override
  List<Object> get props => [userId];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthSignUpSuccess extends AuthState {}

class AuthForgotPasswordSuccess extends AuthState {}

class AuthSignInWithGoogleSuccess extends AuthState {}
