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
import 'package:note_app/features/note/presentation/bloc/note_event.dart';
import 'package:note_app/features/note/presentation/bloc/note_state.dart';
import 'package:flutter/material.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note? note;
  const NoteDetailsScreen({super.key, this.note});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  bool _isVisible = true;
  final QuillController _controller = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _controller.document = Note.toQuillDocument(widget.note!.content);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void _saveNote() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _controller.document.isEmpty()) {
      // Show error message
      return;
    }

    if (widget.note == null) {
      // Create new note
      context.read<NoteBloc>().add(
        CreateNoteEvent(
          title: _titleController.text,
          content: Note.fromQuillDocument(_controller.document),
          description: _descriptionController.text,
        ),
      );
    } else {
      // Update existing note
      final updatedNote = Note(
        id: widget.note!.id,
        title: _titleController.text,
        content: Note.fromQuillDocument(_controller.document),
        description: _descriptionController.text,
      );
      context.read<NoteBloc>().add(UpdateNoteEvent(updatedNote));
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.readOnly = !_isVisible;
    return BlocConsumer<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is NoteOperationSuccess) {
          context.pop();
          context.read<NoteBloc>().add(GetNotesEvent());
        } else if (state is NoteError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
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
                              if (_controller.document.isEmpty() &&
                                  _titleController.text.isEmpty &&
                                  _descriptionController.text.isEmpty) {
                                context.pop();
                              } else {
                                showCustomDialog(
                                  context: context,
                                  confirmText: 'Discard',
                                  cancelText: 'Keep',
                                  contentText:
                                      'Are you sure you want to discard your changes?',
                                  onConfirm: () => context.pop(),
                                );
                              }
                            },
                          ),
                          Row(
                            children: [
                              CustomIcon(
                                icon: Icons.remove_red_eye_outlined,
                                onTap: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              CustomIcon(
                                icon: Icons.save_outlined,
                                onTap: _saveNote,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _titleController,
                        maxLines: null,
                        enabled: _isVisible,
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
                        maxLines: null,
                        enabled: _isVisible,
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                offstage: !_isVisible,
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
