import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/features/authentication/domain/usecases/is_signed_in_usecase.dart';
import 'package:note_app/injection_container.dart';

FutureOr<String?> authMiddleware(BuildContext context, GoRouterState state) {
  final isSignedInResult = sl<IsSignedInUseCase>().call();
  return isSignedInResult.when(
    success: (data) {
      if (data && state.fullPath == "/") {
        return "/notes";
      } else if (!data && state.fullPath != "/") {
        return "/";
      }
      return null;
    },
    error: (error) {
      return null;
    },
  );
}
