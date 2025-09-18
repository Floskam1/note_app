import 'package:get_it/get_it.dart';
import 'package:note_app/core/supabase/supabase.dart';
import 'package:note_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:note_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:note_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:note_app/features/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/get_user_id_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/is_signed_in_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:note_app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:note_app/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_app/features/note/data/datasource/note_remote_data_source.dart';
import 'package:note_app/features/note/data/repositories/note_repository_impl.dart';
import 'package:note_app/features/note/domain/repositories/note_repository.dart';
import 'package:note_app/features/note/domain/usecases/create_note_usecase.dart';
import 'package:note_app/features/note/domain/usecases/delete_note_usecase.dart';
import 'package:note_app/features/note/domain/usecases/get_notes_usecase.dart';
import 'package:note_app/features/note/domain/usecases/update_note_usecase.dart';
import 'package:note_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/note/presentation/bloc/note_details_bloc/note_details_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final sl = GetIt.instance;

Future<void> initial() async {
  // Initialize Supabase first
  await Supabase().initialSupabase();

  // Register Supabase client as lazy singleton
  sl.registerLazySingleton(() => supabase.Supabase.instance.client);

  // Register data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Auth Use Cases
  sl.registerLazySingleton(() => GetUserIdUseCase(sl()));
  sl.registerLazySingleton(() => IsSignedInUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));

  // Auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      getUserIdUseCase: sl(),
      isSignedInUseCase: sl(),
      signInUseCase: sl(),
      signOutUseCase: sl(),
      signUpUseCase: sl(),
      forgotPasswordUseCase: sl(),
      signInWithGoogleUseCase: sl(),
    ),
  );

  // Register data source
  sl.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSourceImpl(client: sl()),
  );

  // Register repository
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(remoteDataSource: sl()),
  );

  // Note Use Cases
  sl.registerLazySingleton(() => GetNotesUsecase(sl()));
  sl.registerLazySingleton(() => CreateNoteUsecase(sl(), sl()));
  sl.registerLazySingleton(() => UpdateNoteUsecase(sl()));
  sl.registerLazySingleton(() => DeleteNoteUsecase(sl()));

  // Note Bloc
  sl.registerFactory(
    () => NoteBloc(
      getNotesUsecase: sl(),
      createNoteUsecase: sl(),
      updateNoteUsecase: sl(),
      deleteNoteUsecase: sl(),
    ),
  );

  // Note Details Bloc
  sl.registerFactory(
    () => NoteDetailsBloc(createNoteUsecase: sl(), updateNoteUsecase: sl()),
  );
}
