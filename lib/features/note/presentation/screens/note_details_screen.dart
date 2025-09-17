import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/core/widgets/custom_icon.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                      Row(
                        children: [
                          CustomIcon(
                            icon: Icons.remove_red_eye_outlined,
                            onTap: () {},
                          ),
                          const SizedBox(width: 10),
                          CustomIcon(icon: Icons.save_outlined, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: TextStyle(color: Colors.white, fontSize: 48),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: AppTheme.hintTextColor,
                        fontSize: 48,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: 23),
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: TextStyle(
                          color: AppTheme.hintTextColor,
                          fontSize: 23,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
