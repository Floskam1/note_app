import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/authentication/domain/usecases/get_user_id_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/is_signed_in_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:note_app/core/usecase/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetUserIdUseCase _getUserIdUseCase;
  final IsSignedInUseCase _isSignedInUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignUpUseCase _signUpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  AuthBloc({
    required GetUserIdUseCase getUserIdUseCase,
    required IsSignedInUseCase isSignedInUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required SignUpUseCase signUpUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  })  : _getUserIdUseCase = getUserIdUseCase,
        _isSignedInUseCase = isSignedInUseCase,
        _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _signUpUseCase = signUpUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthForgotPasswordRequested>(_onAuthForgotPasswordRequested);
    on<AuthSignInWithGoogleRequested>(_onAuthSignInWithGoogleRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final isSignedInResult = _isSignedInUseCase();
    isSignedInResult.when(
      success: (isSignedIn) {
        if (isSignedIn) {
          final userId = _getUserIdUseCase();
          if (userId != null) {
            emit(AuthAuthenticated(userId));
          } else {
            emit(AuthUnauthenticated());
          }
        } else {
          emit(AuthUnauthenticated());
        }
      },
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoginLoading());
    final result = await _signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );
    result.when(
      success: (_) {
        final userId = _getUserIdUseCase();
        if (userId != null) {
          emit(AuthAuthenticated(userId));
        } else {
          emit(AuthError('User ID not found after successful login.'));
        }
      },
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoginLoading());
    final result = await _signOutUseCase();
    result.when(
      success: (_) => emit(AuthUnauthenticated()),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthSignUpLoading());
    final result = await _signUpUseCase(
      SignUpParams(email: event.email, password: event.password),
    );
    result.when(
      success: (_) => emit(AuthSignUpSuccess()),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> _onAuthForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthForgotPasswordLoading());
    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );
    result.when(
      success: (_) => emit(AuthForgotPasswordSuccess()),
      error: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> _onAuthSignInWithGoogleRequested(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthSignInWithGoogleLoading());
    final result = await _signInWithGoogleUseCase(NoParams());
    result.when(
      success: (_) {
        final userId = _getUserIdUseCase();
        if (userId != null) {
          emit(AuthAuthenticated(userId));
        } else {
          emit(AuthError('User ID not found after successful Google login.'));
        }
      },
      error: (failure) => emit(AuthError(failure.message)),
    );
  }
}