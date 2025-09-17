import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/router/app_router.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_app/features/authentication/presentation/widgets/custom_email_form_field.dart';
import 'package:note_app/features/authentication/presentation/widgets/custom_password_form_field.dart';
import 'package:note_app/features/authentication/presentation/widgets/custom_button.dart';
import 'package:note_app/core/utils/snackbar_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(AppRouter.notes);
        } else if (state is AuthError) {
          SnackBarUtils.showErrorSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      "assets/auth/svg/note_logo.svg",
                      height: MediaQuery.of(context).size.width * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.white,
                    ),
                  ),
                ),
                CustomEmailFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomPasswordFormField(
                  hintText: "Password",
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () =>
                          context.pushNamed(AppRouter.forgotPassword),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: state is AuthLoginLoading
                          ? "Signing In..."
                          : "Sign In",
                      onPressed: state is AuthLoginLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<AuthBloc>().add(
                                  AuthLoginRequested(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AuthSignInWithGoogleLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                AuthSignInWithGoogleRequested(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.9,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.white12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/auth/svg/google_logo.svg",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            state is AuthSignInWithGoogleLoading
                                ? "Loading..."
                                : "Continue with Google",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Colors.white12),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1, color: Colors.white12),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed(AppRouter.signUp),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
