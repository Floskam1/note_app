import 'package:note_app/features/note/domain/entities/note_entity.dart';

class NoteModel extends Note {
  const NoteModel({
    super.id,
    required super.title,
    required super.content,
    required super.description,
    super.createdAt,
  });

  factory NoteModel.fromSupabaseJson(Map<String, dynamic> json) => NoteModel(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"] as String),
  );

  Map<String, dynamic> toSupabaseJson() => {
    "title": title,
    "content": content,
    "description": description,
  };
}
