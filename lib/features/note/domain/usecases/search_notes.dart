import 'package:note_app/core/result/result.dart';
import 'package:note_app/core/usecase/usecase.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';

class SearchNotes implements UseCase<List<Note>, String> {
  final NoteRepository repository;

  SearchNotes({required this.repository});

  @override
  Future<Result<List<Note>>> call(String params) async {
    return await repository.searchNotes(params);
  }
}