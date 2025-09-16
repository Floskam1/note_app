import 'package:note_app/core/result/result.dart' hide Failure;
import 'package:note_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Result<bool> isSignedIn() {
    return remoteDataSource.isSignedIn();
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    return await remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<Result<void>> signIn(String email, String password) async {
    return await remoteDataSource.signIn(email, password);
  }

  @override
  Future<Result<void>> signInWithGoogle() async {
    return await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<Result<void>> signOut() async {
    return await remoteDataSource.signOut();
  }

  @override
  Future<Result<void>> signUp(String email, String password) async {
    return await remoteDataSource.signUp(email, password);
  }

  @override
  String? getCurrentUserId() {
    return remoteDataSource.getCurrentUserId();
  }
}
