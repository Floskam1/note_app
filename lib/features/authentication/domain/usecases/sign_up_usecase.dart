import 'package:note_app/core/result/result.dart';
import 'package:note_app/core/usecase/usecase.dart';
import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<void, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Result<void>> call(SignUpParams params) async {
    return await _repository.signUp(params.email, params.password);
  }
}

class SignUpParams {
  final String email;
  final String password;

  SignUpParams({required this.email, required this.password});
}
