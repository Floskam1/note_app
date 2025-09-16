import 'package:flutter/material.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/core/widgets/custom_icon.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notes",
                  style: TextStyle(color: Colors.white, fontSize: 43),
                ),
                Row(
                  children: [
                    CustomIcon(icon: Icons.search_rounded, onTap: () {}),
                    const SizedBox(width: 10),
                    CustomIcon(icon: Icons.info_outline_rounded, onTap: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
