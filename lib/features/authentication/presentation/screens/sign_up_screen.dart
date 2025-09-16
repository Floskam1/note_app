import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/router/app_router.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/core/widgets/custom_icon.dart';
import 'package:note_app/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_app/core/utils/snackbar_utils.dart';
import 'package:note_app/features/authentication/presentation/widgets/custom_button.dart';
import 'package:note_app/features/authentication/presentation/widgets/custom_email_form_field.dart';
import 'package:note_app/features/authentication/presentation/widgets/custom_password_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            SnackBarUtils.showSnackBar(context, 'Sign up successful! Please confirm your email.');
            context.goNamed(AppRouter.signIn);
          } else if (state is AuthError) {
            SnackBarUtils.showSnackBar(context, state.message);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50, left: 30),
                child: CustomIcon(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => context.pop(),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/auth/svg/note_logo.svg",
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      const SizedBox(height: 10),
                      CustomPasswordFormField(
                        hintText: "Confirm Password",
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: state is AuthSignUpLoading
                                ? "Signing Up..."
                                : "Sign Up",
                            onPressed: state is AuthSignUpLoading
                                ? null
                                : () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      context.read<AuthBloc>().add(
                                            AuthSignUpRequested(
                                              email: _emailController.text,
                                              password: _passwordController.text,
                                            ),
                                          );
                                    }
                                  },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
