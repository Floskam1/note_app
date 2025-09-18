import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/router/app_router.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/note/presentation/bloc/note_event.dart';
import 'package:note_app/features/note/presentation/bloc/note_state.dart';
import 'package:note_app/features/note/presentation/widgets/note_widget.dart';

class NoteSearchDelegate extends SearchDelegate<Note?> {
  final NoteBloc noteBloc;

  NoteSearchDelegate(this.noteBloc);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppTheme.hintTextColor),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(titleLarge: TextStyle(color: Colors.white)),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    noteBloc.add(SearchNotesEvent(query));
    return Container(
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<NoteBloc, NoteState>(
          bloc: noteBloc,
          builder: (context, state) {
            if (state is NoteLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is NotesLoaded) {
              if (state.notes.isEmpty) {
                return Center(
                  child: Text(
                    'No notes found for "$query"',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) {
                    final note = state.notes[index];
                    return NoteWidget(
                      note: note,
                      onTap: () {
                        context.pushNamed(AppRouter.noteDetails, extra: note);
                      },
                      onDelete: () {
                        noteBloc.add(DeleteNoteEvent(note.id!));
                      },
                    );
                  },
                );
              }
            } else if (state is NoteError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Search for notes by title',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
