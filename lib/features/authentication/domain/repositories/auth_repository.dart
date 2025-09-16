import 'package:note_app/core/result/result.dart' hide Failure;

abstract class AuthRepository {
  Future<Result<void>> signIn(String email, String password);
  Future<Result<void>> signUp(String email, String password);
  Future<Result<void>> forgotPassword({required String email});
  Future<Result<void>> signInWithGoogle();
  Future<Result<void>> signOut();
  Result<bool> isSignedIn();
  String? getCurrentUserId();
}
