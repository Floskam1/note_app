import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';

abstract class NoteRepository {
  Future<Result<List<Note>>> getNotes();
  Future<Result<void>> createNote(Note note);
  Future<Result<void>> updateNote(Note note);
  Future<Result<void>> deleteNote(String id);
  Future<Result<List<Note>>> searchNotes(String query);
}
