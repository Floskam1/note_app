import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';

class GetUserIdUseCase {
  final AuthRepository _repository;

  GetUserIdUseCase(this._repository);

  String? call() {
    return _repository.getCurrentUserId();
  }
}
