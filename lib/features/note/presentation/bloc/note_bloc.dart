import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/usecases/create_note_usecase.dart';
import 'package:note_app/features/note/domain/usecases/delete_note_usecase.dart';
import 'package:note_app/features/note/domain/usecases/get_notes_usecase.dart';
import 'package:note_app/features/note/domain/usecases/update_note_usecase.dart';
import 'package:note_app/features/note/presentation/bloc/note_event.dart';
import 'package:note_app/features/note/presentation/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotesUsecase getNotesUsecase;
  final CreateNoteUsecase createNoteUsecase;
  final UpdateNoteUsecase updateNoteUsecase;
  final DeleteNoteUsecase deleteNoteUsecase;

  NoteBloc({
    required this.getNotesUsecase,
    required this.createNoteUsecase,
    required this.updateNoteUsecase,
    required this.deleteNoteUsecase,
  }) : super(NoteInitial()) {
    on<GetNotesEvent>(_onGetNotes);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
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
    final result = await createNoteUsecase.call(note);
    result.when(
      success: (_) => emit(NoteOperationSuccess()),
      error: (failure) => emit(NoteError(failure.message)),
    );
  }

  void _onUpdateNote(UpdateNoteEvent event, Emitter<NoteState> emit) async {
    final result = await updateNoteUsecase.call(event.note);
    result.when(
      success: (_) => emit(NoteOperationSuccess()),
      error: (failure) => emit(NoteError(failure.message)),
    );
  }

  void _onDeleteNote(DeleteNoteEvent event, Emitter<NoteState> emit) async {
    final result = await deleteNoteUsecase.call(event.id);
    result.when(
      success: (_) => emit(NoteOperationSuccess()),
      error: (failure) => emit(NoteError(failure.message)),
    );
  }
}
