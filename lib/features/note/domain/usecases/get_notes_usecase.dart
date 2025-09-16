import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';

class GetNotesUsecase {
  final NoteRepository repository;
  GetNotesUsecase(this.repository);
  Future<Result<List<Note>>> call() => repository.getNotes();
}
