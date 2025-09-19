import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/router/app_router.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/core/widgets/custom_icon.dart';
import 'package:note_app/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/note/presentation/bloc/note_event.dart';
import 'package:note_app/features/note/presentation/bloc/note_state.dart';
import 'package:note_app/features/note/presentation/widgets/empty_notes.dart';
import 'package:note_app/features/note/presentation/widgets/note_widget.dart';
import 'package:note_app/features/note/presentation/widgets/note_search_delegate.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.goNamed(AppRouter.signIn);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(color: Colors.white, fontSize: 43),
                  ),
                  Row(
                    children: [
                      CustomIcon(
                        icon: Icons.search_rounded,
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: NoteSearchDelegate(
                              context.read<NoteBloc>(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      CustomIcon(
                        icon: Icons.logout_rounded,
                        onTap: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<NoteBloc, NoteState>(
                  builder: (context, state) {
                    if (state is NoteLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is NotesLoaded) {
                      if (state.notes.isEmpty) {
                        return const EmptyNotes();
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                context.goNamed(
                                  AppRouter.noteDetails,
                                  extra: note,
                                );
                              },
                              onDelete: () {
                                context.read<NoteBloc>().add(
                                  DeleteNoteEvent(note.id!),
                                );
                              },
                            );
                          },
                        );
                      }
                    } else if (state is NoteError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: getFloatingActionButton(context),
      ),
    );
  }

  Widget getFloatingActionButton(BuildContext context) => FloatingActionButton(
    onPressed: () => context.goNamed(AppRouter.noteDetails),
    backgroundColor: AppTheme.primaryColor,
    child: Icon(Icons.add, color: Colors.white, size: 30),
  );
}
