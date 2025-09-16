import 'package:note_app/core/result/result.dart';
import 'package:note_app/core/usecase/usecase.dart';
import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  @override
  Future<Result<void>> call(NoParams params) async {
    return await _repository.signInWithGoogle();
  }
}
