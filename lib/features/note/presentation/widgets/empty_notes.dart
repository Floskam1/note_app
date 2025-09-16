import 'package:flutter/material.dart';

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/notes/png/empty_notes.png",
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
          ),
          Text(
            "Create your first note !",
            style: TextStyle(color: Colors.white60, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
