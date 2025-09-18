import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';

class Note extends Equatable {
  final String? id;
  final String title;
  final String content;
  final String description;
  final DateTime? createdAt;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.description,
    this.createdAt,
  });

  static String fromQuillDocument(Document document) {
    return jsonEncode(document.toDelta().toJson());
  }

  static Document toQuillDocument(String jsonString) {
    return Document.fromJson(jsonDecode(jsonString));
  }

  @override
  List<Object?> get props => [id, title, content, description, createdAt];
}
