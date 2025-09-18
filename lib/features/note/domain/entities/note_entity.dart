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
    final plainText = document.toPlainText();
    if (plainText.trim().isEmpty) {
      return '';
    }
    return jsonEncode(document.toDelta().toJson());
  }

  static Document toQuillDocument(String jsonString) {
    if (jsonString.isEmpty) {
      return Document();
    }
    try {
      return Document.fromJson(jsonDecode(jsonString));
    } on FormatException {
      return Document();
    } catch (e) {
      return Document();
    }
  }

  @override
  List<Object?> get props => [id, title, content, description, createdAt];
}
