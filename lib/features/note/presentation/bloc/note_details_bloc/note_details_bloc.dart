import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/usecases/create_note_usecase.dart';
import 'package:note_app/features/note/domain/usecases/update_note_usecase.dart';
import 'package:note_app/features/note/presentation/bloc/note_details_bloc/note_details_event.dart';
import 'package:note_app/features/note/presentation/bloc/note_details_bloc/note_details_state.dart';

class NoteDetailsBloc extends Bloc<NoteDetailsEvent, NoteDetailsState> {
  final CreateNoteUsecase createNoteUsecase;
  final UpdateNoteUsecase updateNoteUsecase;

  NoteDetailsBloc({
    required this.createNoteUsecase,
    required this.updateNoteUsecase,
    Note? initialNote,
  }) : super(
         NoteDetailsState(
           id: initialNote?.id,
           title: initialNote?.title ?? '',
           content: initialNote?.content ?? '',
           description: initialNote?.description ?? '',
           createdAt: initialNote?.createdAt,
           initialNote: initialNote,
         ),
       ) {
    on<NoteDetailsLoadEvent>(_onNoteDetailsLoad);
    on<NoteDetailsTitleChanged>(_onNoteDetailsTitleChanged);
    on<NoteDetailsDescriptionChanged>(_onNoteDetailsDescriptionChanged);
    on<NoteDetailsContentChanged>(_onNoteDetailsContentChanged);
    on<NoteDetailsToggleVisibility>(_onNoteDetailsToggleVisibility);
    on<NoteDetailsSaveRequested>(_onNoteDetailsSaveRequested);
    on<NoteDetailsDiscardRequested>(_onNoteDetailsDiscardRequested);
    on<NoteDetailsConfirmDiscardEvent>(_onNoteDetailsConfirmDiscardEvent);
  }

  void _onNoteDetailsLoad(
    NoteDetailsLoadEvent event,
    Emitter<NoteDetailsState> emit,
  ) {
    emit(
      state.copyWith(
        id: event.initialNote?.id,
        title: event.initialNote?.title ?? '',
        content: event.initialNote?.content ?? '',
        description: event.initialNote?.description ?? '',
        createdAt: event.initialNote?.createdAt,
        initialNote: event.initialNote,
        discardConfirmationNeeded: false,
        operationCompleted: false,
      ),
    );
  }

  void _onNoteDetailsTitleChanged(
    NoteDetailsTitleChanged event,
    Emitter<NoteDetailsState> emit,
  ) {
    emit(state.copyWith(title: event.title, operationCompleted: false));
  }

  void _onNoteDetailsDescriptionChanged(
    NoteDetailsDescriptionChanged event,
    Emitter<NoteDetailsState> emit,
  ) {
    emit(
      state.copyWith(description: event.description, operationCompleted: false),
    );
  }

  void _onNoteDetailsContentChanged(
    NoteDetailsContentChanged event,
    Emitter<NoteDetailsState> emit,
  ) {
    emit(state.copyWith(content: event.content, operationCompleted: false));
  }

  void _onNoteDetailsToggleVisibility(
    NoteDetailsToggleVisibility event,
    Emitter<NoteDetailsState> emit,
  ) {
    emit(
      state.copyWith(isVisible: !state.isVisible, operationCompleted: false),
    );
  }

  void _onNoteDetailsSaveRequested(
    NoteDetailsSaveRequested event,
    Emitter<NoteDetailsState> emit,
  ) async {
    final contentDocument = Note.toQuillDocument(state.content);
    final contentPlainText = contentDocument.toPlainText().trim();

    if (state.title.trim().isEmpty ||
        state.description.trim().isEmpty ||
        contentPlainText.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'All fields must be filled.',
          discardConfirmationNeeded: false,
          operationCompleted: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSaving: true,
        errorMessage: null,
        discardConfirmationNeeded: false,
        operationCompleted: false,
      ),
    );

    final noteToSave = Note(
      id: state.id,
      title: state.title.trim(),
      content: state.content,
      description: state.description.trim(),
      createdAt: state.createdAt,
    );

    Result<void> result;
    if (state.id == null) {
      result = await createNoteUsecase.call(noteToSave);
    } else {
      result = await updateNoteUsecase.call(noteToSave);
    }

    result.when(
      success: (_) => emit(
        state.copyWith(
          isSaving: false,
          errorMessage: null,
          discardConfirmationNeeded: false,
          operationCompleted: true,
        ),
      ),
      error: (failure) => emit(
        state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
          discardConfirmationNeeded: false,
          operationCompleted: false,
        ),
      ),
    );
  }

  void _onNoteDetailsDiscardRequested(
    NoteDetailsDiscardRequested event,
    Emitter<NoteDetailsState> emit,
  ) {
    final hasChanges =
        !(state.title == (state.initialNote?.title ?? '') &&
            state.content == (state.initialNote?.content ?? '') &&
            state.description == (state.initialNote?.description ?? ''));

    if (!hasChanges) {
      emit(
        state.copyWith(
          errorMessage: null,
          discardConfirmationNeeded: false,
          operationCompleted: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          discardConfirmationNeeded: true,
          errorMessage: null,
          operationCompleted: false,
        ),
      );
    }
  }

  void _onNoteDetailsConfirmDiscardEvent(
    NoteDetailsConfirmDiscardEvent event,
    Emitter<NoteDetailsState> emit,
  ) {
    emit(
      state.copyWith(
        errorMessage: null,
        discardConfirmationNeeded: false,
        operationCompleted: true,
      ),
    ); // Signals pop
  }
}
