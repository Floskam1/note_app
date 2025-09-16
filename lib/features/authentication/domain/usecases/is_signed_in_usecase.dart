import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:note_app/core/result/result.dart';

class IsSignedInUseCase {
  final AuthRepository _repository;

  IsSignedInUseCase(this._repository);

  Result<bool> call() {
    return _repository.isSignedIn();
  }
}
