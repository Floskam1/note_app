import 'package:equatable/equatable.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';

abstract class NoteDetailsEvent extends Equatable {
  const NoteDetailsEvent();

  @override
  List<Object?> get props => [];
}

class NoteDetailsLoadEvent extends NoteDetailsEvent {
  final Note? initialNote;

  const NoteDetailsLoadEvent({this.initialNote});

  @override
  List<Object?> get props => [initialNote];
}

class NoteDetailsTitleChanged extends NoteDetailsEvent {
  final String title;

  const NoteDetailsTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class NoteDetailsDescriptionChanged extends NoteDetailsEvent {
  final String description;

  const NoteDetailsDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class NoteDetailsContentChanged extends NoteDetailsEvent {
  final String content;

  const NoteDetailsContentChanged(this.content);

  @override
  List<Object?> get props => [content];
}

class NoteDetailsToggleVisibility extends NoteDetailsEvent {
  const NoteDetailsToggleVisibility();
}

class NoteDetailsSaveRequested extends NoteDetailsEvent {
  const NoteDetailsSaveRequested();
}

class NoteDetailsDiscardRequested extends NoteDetailsEvent {
  const NoteDetailsDiscardRequested();
}

class NoteDetailsConfirmDiscardEvent extends NoteDetailsEvent {
  const NoteDetailsConfirmDiscardEvent();
}
