import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/data/datasource/note_remote_data_source.dart';
import 'package:note_app/features/note/data/models/note_model.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;

  NoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Note>>> getNotes() async {
    final result = await remoteDataSource.getNotes();

    return result.when(
      success: (noteModels) {
        final notes = noteModels
            .map(
              (model) => Note(
                id: model.id,
                title: model.title,
                content: model.content,
                description: model.description,
                createdAt: model.createdAt,
              ),
            )
            .toList();
        return Success(notes);
      },
      error: (failure) => Failure(failure),
    );
  }

  @override
  Future<Result<void>> createNote(Note note) async {
    final noteModel = NoteModel(
      title: note.title,
      content: note.content,
      description: note.description,
    );

    final result = await remoteDataSource.createNote(noteModel);
    return result.when(
      success: (_) => Success(null),
      error: (failure) => Failure(failure),
    );
  }

  @override
  Future<Result<void>> updateNote(Note note) async {
    final noteModel = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      description: note.description,
    );

    final result = await remoteDataSource.updateNote(noteModel);
    return result.when(
      success: (_) => Success(null),
      error: (failure) => Failure(failure),
    );
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    final result = await remoteDataSource.deleteNote(id);
    return result.when(
      success: (_) => Success(null),
      error: (failure) => Failure(failure),
    );
  }
}
