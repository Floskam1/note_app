import 'package:note_app/core/failure/failures.dart' as failures;
import 'package:note_app/core/result/result.dart';
import 'package:note_app/features/note/data/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NoteRemoteDataSource {
  Future<Result<List<NoteModel>>> getNotes();
  Future<Result<void>> createNote(NoteModel note);
  Future<Result<void>> updateNote(NoteModel note);
  Future<Result<void>> deleteNote(String id);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final SupabaseClient client;

  NoteRemoteDataSourceImpl({required this.client});

  @override
  Future<Result<void>> createNote(NoteModel note) async {
    try {
      await client.from("notes").insert(note.toJson());
      return Success(null);
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    try {
      await client.from("notes").delete().match({"id": id});
      return Success(null);
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NoteModel>>> getNotes() async {
    try {
      final notes = await client.from("notes").select();
      return Success(notes.map((e) => NoteModel.fromJson(e)).toList());
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateNote(NoteModel note) async {
    try {
      await client.from("notes").update(note.toJson()).match({"id": note.id});
      return Success(null);
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }
}
