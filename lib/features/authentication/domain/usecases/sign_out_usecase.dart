import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Result<void>> call() {
    return _repository.signOut();
  }
}
