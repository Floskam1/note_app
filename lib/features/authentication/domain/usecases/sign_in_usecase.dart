import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Result<void>> call(SignInParams params) {
    return _repository.signIn(params.email, params.password);
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
