import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final String description;
  final DateTime? createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    description,
    createdAt,
  ];
}
