import 'package:equatable/equatable.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class GetNotesEvent extends NoteEvent {}

class CreateNoteEvent extends NoteEvent {
  final String title;
  final String content;
  final String description;

  const CreateNoteEvent({
    required this.title,
    required this.content,
    required this.description,
  });

  @override
  List<Object> get props => [title, content, description];
}

class UpdateNoteEvent extends NoteEvent {
  final Note note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNoteEvent extends NoteEvent {
  final String id;

  const DeleteNoteEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SearchNotesEvent extends NoteEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object> get props => [query];
}
