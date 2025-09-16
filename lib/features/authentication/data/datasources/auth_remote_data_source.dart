import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/core/failure/failures.dart';
import 'package:note_app/core/result/result.dart' hide Failure;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<Result<void>> signIn(String email, String password);
  Future<Result<void>> signUp(String email, String password);
  Future<Result<void>> forgotPassword({required String email});
  Future<Result<void>> signInWithGoogle();
  Future<Result<void>> signOut();
  Result<bool> isSignedIn();
  String? getCurrentUserId();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Result<bool> isSignedIn() {
    final isSignedIn = client.auth.currentUser != null;
    return Success(isSignedIn);
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      return Success(null);
    } on AuthException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.session != null) {
        return Success(null);
      } else {
        return Result.failure(ServerFailure('Unknown authentication error'));
      }
    } on AuthException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signInWithGoogle() async {
    try {
      const iosClientId =
          "1088795448800-4r17gaaggi15r1rrnif5jvr3j7pcq4jd.apps.googleusercontent.com";

      const webClientId =
          '1088795448800-i3l3d168hmqmdse3b311tk7e95t7mlh3.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      googleSignIn.initialize(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleSignInAccount = await googleSignIn
          .attemptLightweightAuthentication();
      if (googleSignInAccount == null) {
        return Result.failure(ServerFailure('Google Sign-In aborted by user.'));
      }
      final googleAuth = googleSignInAccount.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        return Result.failure(ServerFailure('No ID Token found.'));
      }
      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      return Success(null);
    } on AuthException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await client.auth.signOut();
      return Success(null);
    } on AuthException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signUp(String email, String password) async {
    try {
      await client.auth.signUp(password: password, email: email);
      return Success(null);
    } on AuthException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  String? getCurrentUserId() {
    return client.auth.currentUser?.id;
  }
}
