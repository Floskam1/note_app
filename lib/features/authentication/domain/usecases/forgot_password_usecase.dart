import 'package:note_app/core/result/result.dart';
import 'package:note_app/core/usecase/usecase.dart';
import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Result<void>> call(ForgotPasswordParams params) async {
    return await _repository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});
}
