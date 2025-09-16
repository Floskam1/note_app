import 'package:note_app/features/note/domain/entities/note_entity.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.description,
    required super.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    description: json["description"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "description": description,
    "created_at": createdAt,
  };
}
