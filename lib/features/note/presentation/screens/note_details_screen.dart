import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/core/quill/default_list_block_style.dart';
import 'package:note_app/core/quill/default_text_block_style.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/core/quill/quill_tool_bar_config.dart';
import 'package:note_app/core/utils/show_custom_dialog.dart';
import 'package:note_app/core/widgets/custom_icon.dart';
import 'package:note_app/features/note/domain/entities/note_entity.dart';
import 'package:note_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/note/presentation/bloc/note_details_bloc/note_details_bloc.dart';
import 'package:note_app/features/note/presentation/bloc/note_details_bloc/note_details_event.dart';
import 'package:note_app/features/note/presentation/bloc/note_details_bloc/note_details_state.dart';
import 'package:flutter/material.dart';
import 'package:note_app/features/note/presentation/bloc/note_event.dart'; // This import is necessary for GetNotesEvent
import 'package:note_app/injection_container.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note? note;
  const NoteDetailsScreen({super.key, this.note});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _isContentListenerAdded = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _controller.document = Note.toQuillDocument(widget.note!.content);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(() => _onContentChanged(context));
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onContentChanged(BuildContext context) {
    final content = Note.fromQuillDocument(_controller.document);
    context.read<NoteDetailsBloc>().add(NoteDetailsContentChanged(content));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteDetailsBloc>(
      create: (context) => NoteDetailsBloc(
        createNoteUsecase: sl(),
        updateNoteUsecase: sl(),
        initialNote: widget.note,
      )..add(NoteDetailsLoadEvent(initialNote: widget.note)),
      child: BlocConsumer<NoteDetailsBloc, NoteDetailsState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          } else if (state.discardConfirmationNeeded) {
            showCustomDialog(
              context: context,
              confirmText: 'Discard',
              cancelText: 'Keep',
              contentText: 'Are you sure you want to discard your changes?',
              onConfirm: () {
                context.read<NoteDetailsBloc>().add(
                  const NoteDetailsConfirmDiscardEvent(),
                );
                context.pop();
              },
            );
          } else if (state.operationCompleted) {
            context.pop();
            context.read<NoteBloc>().add(GetNotesEvent());
          }
        },
        builder: (context, state) {
          if (!_isContentListenerAdded) {
            _controller.addListener(() {
              _onContentChanged(context);
            });
            _isContentListenerAdded = true;
          }
          if (_titleController.text != state.title) {
            _titleController.text = state.title;
            _titleController.selection = TextSelection.collapsed(
              offset: state.title.length,
            );
          }
          if (_descriptionController.text != state.description) {
            _descriptionController.text = state.description;
            _descriptionController.selection = TextSelection.collapsed(
              offset: state.description.length,
            );
          }
          _controller.readOnly = !state.isVisible;

          return Scaffold(
            backgroundColor: AppTheme.primaryColor,
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIcon(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () {
                                context.read<NoteDetailsBloc>().add(
                                  const NoteDetailsDiscardRequested(),
                                );
                              },
                            ),
                            Row(
                              children: [
                                CustomIcon(
                                  icon: state.isVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  onTap: () {
                                    context.read<NoteDetailsBloc>().add(
                                      const NoteDetailsToggleVisibility(),
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                CustomIcon(
                                  icon: Icons.save_outlined,
                                  onTap: () {
                                    context.read<NoteDetailsBloc>().add(
                                      const NoteDetailsSaveRequested(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _titleController,
                          onChanged: (value) => context
                              .read<NoteDetailsBloc>()
                              .add(NoteDetailsTitleChanged(value)),
                          maxLines: null,
                          enabled: state.isVisible,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(color: AppTheme.hintTextColor),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _descriptionController,
                          onChanged: (value) => context
                              .read<NoteDetailsBloc>()
                              .add(NoteDetailsDescriptionChanged(value)),
                          maxLines: null,
                          enabled: state.isVisible,
                          style: TextStyle(color: Colors.white, fontSize: 23),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(color: AppTheme.hintTextColor),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: QuillEditor(
                            focusNode: _focusNode,
                            scrollController: _scrollController,
                            controller: _controller,
                            config: QuillEditorConfig(
                              customStyles: customStyles,
                              placeholder: 'Type something...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: !state.isVisible,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 60,
                    width: double.infinity,
                    child: quillSimpleToolbarConfig(_controller),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DefaultStyles get customStyles => DefaultStyles(
    paragraph: defaultTextBlockStyle(),
    h1: defaultTextBlockStyle(fontSize: 32),
    h2: defaultTextBlockStyle(fontSize: 28),
    h3: defaultTextBlockStyle(fontSize: 24),
    placeHolder: defaultListBlockStyle,
  );
}
