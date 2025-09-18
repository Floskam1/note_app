import 'package:equatable/equatable.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';

class NoteDetailsState extends Equatable {
  final String? id;
  final String title;
  final String content;
  final String description;
  final DateTime? createdAt;
  final bool isVisible;
  final bool isSaving;
  final String? errorMessage;
  final Note? initialNote;
  final bool discardConfirmationNeeded;
  final bool operationCompleted;

  const NoteDetailsState({
    this.id,
    required this.title,
    required this.content,
    required this.description,
    this.createdAt,
    this.isVisible = true,
    this.isSaving = false,
    this.errorMessage,
    this.initialNote,
    this.discardConfirmationNeeded = false,
    this.operationCompleted = false,
  });

  NoteDetailsState copyWith({
    String? id,
    String? title,
    String? content,
    String? description,
    DateTime? createdAt,
    bool? isVisible,
    bool? isSaving,
    String? errorMessage,
    Note? initialNote,
    bool? discardConfirmationNeeded,
    bool? operationCompleted,
  }) {
    return NoteDetailsState(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isVisible: isVisible ?? this.isVisible,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      initialNote: initialNote ?? this.initialNote,
      discardConfirmationNeeded:
          discardConfirmationNeeded ?? this.discardConfirmationNeeded,
      operationCompleted: operationCompleted ?? this.operationCompleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    description,
    createdAt,
    isVisible,
    isSaving,
    errorMessage,
    initialNote,
    discardConfirmationNeeded,
    operationCompleted,
  ];
}
