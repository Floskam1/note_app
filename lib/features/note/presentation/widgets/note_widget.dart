import 'package:flutter/material.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    super.key,
    required this.noteColor,
    required this.noteTitle,
  });

  final String noteTitle;
  final Color noteColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: noteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          noteTitle,
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
    );
  }
}
