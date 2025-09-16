import 'package:note_app/features/authentication/domain/entities/auth_entity.dart';

class AuthModel extends Auth {
  const AuthModel({required super.email, required super.password});

  factory AuthModel.fromEntity(Auth entity) {
    return AuthModel(email: entity.email, password: entity.password);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
