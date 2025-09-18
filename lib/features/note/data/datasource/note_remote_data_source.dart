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
      await client
          .from("notes")
          .insert(
            note.toSupabaseJson()
              ..remove("id")
              ..remove("created_at")
              ..remove("user_id"),
          );
      return Success(null);
    } on PostgrestException catch (e) {
      return Failure(failures.ServerFailure(e.message));
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteNote(String id) async {
    try {
      await client.from("notes").delete().eq("id", id);
      return Success(null);
    } on PostgrestException catch (e) {
      return Failure(failures.ServerFailure(e.message));
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NoteModel>>> getNotes() async {
    try {
      final response = await client
          .from("notes")
          .select()
          .eq("user_id", client.auth.currentUser!.id);
      final notes = (response as List)
          .map((e) => NoteModel.fromSupabaseJson(e as Map<String, dynamic>))
          .toList();
      return Success(notes);
    } on PostgrestException catch (e) {
      return Failure(failures.ServerFailure(e.message));
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateNote(NoteModel note) async {
    try {
      await client
          .from("notes")
          .update(note.toSupabaseJson()..remove("created_at"))
          .eq("id", note.id!);
      return Success(null);
    } on PostgrestException catch (e) {
      return Failure(failures.ServerFailure(e.message));
    } catch (e) {
      return Failure(failures.ServerFailure(e.toString()));
    }
  }
}
