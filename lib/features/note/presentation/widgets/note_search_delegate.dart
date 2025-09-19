import 'package:flutter/material.dart';
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
    final cachedNotes = (noteBloc.state is NotesLoaded)
        ? (noteBloc.state as NotesLoaded).notes
        : <Note>[];
    final filteredNotes = query.isEmpty
        ? cachedNotes
        : cachedNotes
              .where(
                (note) =>
                    note.title.toLowerCase().contains(query.toLowerCase()) ||
                    (note.description.toLowerCase().contains(
                      query.toLowerCase(),
                    )),
              )
              .toList();

    return Container(
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildNotesList(context, filteredNotes),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final cachedNotes = (noteBloc.state is NotesLoaded)
        ? (noteBloc.state as NotesLoaded).notes
        : <Note>[];

    final filteredNotes = query.isEmpty
        ? <Note>[]
        : cachedNotes
              .where(
                (note) =>
                    note.title.toLowerCase().contains(query.toLowerCase()) ||
                    (note.description.toLowerCase().contains(
                      query.toLowerCase(),
                    )),
              )
              .toList();

    if (query.isEmpty) {
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

    return Container(
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildNotesList(context, filteredNotes),
      ),
    );
  }

  Widget _buildNotesList(BuildContext context, List<Note> notes) {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/notes/png/no_notes_found.png",
              width: MediaQuery.of(context).size.width * .8,
            ),
            Text(
              textAlign: TextAlign.center,
              query.isEmpty
                  ? 'No notes available.'
                  : 'No notes found for "$query".',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
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
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
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
  }
}
