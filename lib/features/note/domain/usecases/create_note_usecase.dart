import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';
import 'package:note_app/features/authentication/domain/usecases/get_user_id_usecase.dart';
import 'package:note_app/core/failure/failures.dart';

class CreateNoteUsecase {
  final NoteRepository repository;
  final GetUserIdUseCase getUserIdUseCase;
  CreateNoteUsecase(this.repository, this.getUserIdUseCase);

  Future<Result<void>> call(Note note) {
    final userId = getUserIdUseCase.call();
    if (userId == null) {
      return Future.value(
        Result.failure(ServerFailure('User not authenticated')),
      );
    }
    final noteToCreate = Note(
      title: note.title,
      content: note.content,
      description: note.description,
    );
    return repository.createNote(noteToCreate);
  }
}
