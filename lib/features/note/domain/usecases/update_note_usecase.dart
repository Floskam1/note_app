import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';

class UpdateNoteUsecase {
  final NoteRepository repository;
  UpdateNoteUsecase(this.repository);
  Future<Result<void>> call(Note note) => repository.updateNote(note);
}