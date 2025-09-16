import 'package:flutter/material.dart';
import 'package:note_app/core/theme/app_theme.dart';

class CustomEmailFormField extends StatelessWidget {
  const CustomEmailFormField({super.key, required this.controller, this.validator});

  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      decoration: InputDecoration(
        hintText: "Enter your email",
        hintStyle: const TextStyle(color: Colors.white70),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: AppTheme.secondaryColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}
