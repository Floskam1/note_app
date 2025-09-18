import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/usecases/create_note_usecase.dart';
import 'package:note_app/features/note/domain/usecases/delete_note_usecase.dart';
import 'package:note_app/features/note/domain/usecases/get_notes_usecase.dart';
import 'package:note_app/features/note/domain/usecases/search_notes.dart';
import 'package:note_app/features/note/domain/usecases/update_note_usecase.dart';
import 'package:note_app/features/note/presentation/bloc/note_event.dart';
import 'package:note_app/features/note/presentation/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotesUsecase getNotesUsecase;
  final CreateNoteUsecase createNoteUsecase;
  final UpdateNoteUsecase updateNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;
  final SearchNotes searchNotes;

  NoteBloc({
    required this.getNotesUsecase,
    required this.createNoteUsecase,
    required this.updateNoteUsecase,
    required this.deleteNoteUsecase,
    required this.searchNotes,
  }) : super(NoteInitial()) {
    on<GetNotesEvent>(_onGetNotes);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SearchNotesEvent>(_onSearchNotes);
  }

  void _onGetNotes(GetNotesEvent event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    final result = await getNotesUsecase.call();
    result.when(
      success: (notes) => emit(NotesLoaded(notes)),
      error: (failure) => emit(NoteError(failure.message)),
    );
  }

  void _onCreateNote(CreateNoteEvent event, Emitter<NoteState> emit) async {
    final note = Note(
      title: event.title,
      content: event.content,
      description: event.description,
    );
    try {
      final result = await createNoteUsecase.call(note);
      await result.when(
        success: (_) async {
          final notesResult = await getNotesUsecase.call();
          await notesResult.when(
            success: (notes) {
              if (!emit.isDone) {
                emit(NotesLoaded(notes));
              }
            },
            error: (failure) {
              if (!emit.isDone) emit(NoteError(failure.message));
            },
          );
        },
        error: (failure) {
          if (!emit.isDone) emit(NoteError(failure.message));
        },
      );
    } catch (e) {
      if (!emit.isDone) emit(NoteError(e.toString()));
    }
  }

  void _onUpdateNote(UpdateNoteEvent event, Emitter<NoteState> emit) async {
    try {
      final result = await updateNoteUsecase.call(event.note);
      await result.when(
        success: (_) async {
          final notesResult = await getNotesUsecase.call();
          await notesResult.when(
            success: (notes) {
              if (!emit.isDone) emit(NotesLoaded(notes));
            },
            error: (failure) {
              if (!emit.isDone) emit(NoteError(failure.message));
            },
          );
        },
        error: (failure) {
          if (!emit.isDone) emit(NoteError(failure.message));
        },
      );
    } catch (e) {
      if (!emit.isDone) emit(NoteError(e.toString()));
    }
  }

  void _onDeleteNote(DeleteNoteEvent event, Emitter<NoteState> emit) async {
    try {
      final result = await deleteNoteUsecase.call(event.id);
      await result.when(
        success: (_) async {
          final notesResult = await getNotesUsecase.call();
          await notesResult.when(
            success: (notes) {
              if (!emit.isDone) {
                emit(NotesLoaded(notes));
              }
            },
            error: (failure) {
              if (!emit.isDone) emit(NoteError(failure.message));
            },
          );
        },
        error: (failure) {
          if (!emit.isDone) emit(NoteError(failure.message));
        },
      );
    } catch (e) {
      if (!emit.isDone) emit(NoteError(e.toString()));
    }
  }

  void _onSearchNotes(SearchNotesEvent event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    final result = await searchNotes.call(event.query);
    result.when(
      success: (notes) => emit(NotesLoaded(notes)),
      error: (failure) => emit(NoteError(failure.message)),
    );
  }
}
