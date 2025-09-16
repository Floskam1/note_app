import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';

class CreateNoteUsecase {
  final NoteRepository repository;
  CreateNoteUsecase(this.repository);
  Future<Result<void>> call(Note note) => repository.createNote(note);
}
