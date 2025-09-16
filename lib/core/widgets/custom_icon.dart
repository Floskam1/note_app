import 'package:flutter/material.dart';
import 'package:note_app/core/theme/app_theme.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CustomIcon({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(child: Icon(icon, color: Colors.white70, size: 25)),
      ),
    );
  }
}
