import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';

class DeleteNoteUsecase {
  final NoteRepository noteRepository;
  DeleteNoteUsecase(this.noteRepository);
  Future<Result<void>> call(String id) => noteRepository.deleteNote(id);
}
