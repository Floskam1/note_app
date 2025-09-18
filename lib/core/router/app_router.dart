import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/middlewares/auth_middleware.dart';
import 'package:note_app/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:note_app/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:note_app/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/presentation/screens/note_details_screen.dart';
import 'package:note_app/features/note/presentation/screens/notes_screen.dart';

class AppRouter {
  static const String signUp = "sign-up";
  static const String signIn = "sign-in";
  static const String forgotPassword = "forgot-password";
  static const String notes = "notes";
  static const String noteDetails = "note-details";

  GoRouter get routerConfig => GoRouter(
    initialLocation: "/",
    routes: <RouteBase>[
      GoRoute(
        name: signIn,
        path: "/",
        redirect: authMiddleware,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        name: notes,
        path: "/notes",
        routes: [
          GoRoute(
            name: noteDetails,
            path: "/note-details",
            builder: (context, state) {
              final note = state.extra as Note?;
              return NoteDetailsScreen(note: note);
            },
          ),
        ],
        builder: (context, state) => const NotesScreen(),
      ),
      GoRoute(
        name: signUp,
        path: "/sign-up",
        pageBuilder: (context, state) =>
            _signInTransitionBuilder(context, state, const SignUpScreen()),
      ),
      GoRoute(
        name: forgotPassword,
        path: "/forgot-password",
        pageBuilder: (context, state) => _signInTransitionBuilder(
          context,
          state,
          const ForgotPasswordScreen(),
        ),
      ),
    ],
  );

  CustomTransitionPage _signInTransitionBuilder(
    BuildContext context,
    state,
    child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0.5, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
            ),
            child: child,
          ),
    );
  }
}
