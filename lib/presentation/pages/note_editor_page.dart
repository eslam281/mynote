import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart' as sp;
import '../../data/models/note_model.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../../logic/notes_cubit/notes_state.dart';
import '../../logic/services/file_service.dart';
import '../../logic/services/pdf_service.dart';
import '../widgets/editor/attachments_bar.dart';
import '../widgets/editor/editor_bottom_panel.dart';
import '../widgets/common/confirmation_dialogs.dart';
import '../widgets/common/custom_bottom_sheets.dart';

class NoteEditorPage extends StatefulWidget {
  final NoteModel? note;

  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedColor;
  late bool _isPinned;
  late bool _isLocked;
  String? _selectedCategory;
  List<String> _attachments = [];

  final List<int> _colors = [
    0xFFFFFFFF, 0xFFF28B82, 0xFFFBBC04, 0xFFFFF475,
    0xFFCCFF90, 0xFFA7FFEB, 0xFFCBF0F8, 0xFFAECBFA,
    0xFFD7AEFB, 0xFFFDCFE8, 0xFFE6C9A8, 0xFFE8EAED,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = widget.note?.color ?? _colors[0];
    _isPinned = widget.note?.isPinned ?? false;
    _isLocked = widget.note?.isLocked ?? false;
    _selectedCategory = widget.note?.category;
    _attachments = List.from(widget.note?.attachments ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (widget.note == null) {
      return title.isNotEmpty || content.isNotEmpty || _attachments.isNotEmpty;
    }
    return title != widget.note!.title ||
        content != widget.note!.content ||
        _selectedColor != widget.note!.color ||
        _isPinned != widget.note!.isPinned ||
        _isLocked != widget.note!.isLocked ||
        _selectedCategory != widget.note!.category ||
        _attachments.length != widget.note!.attachments.length;
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty && _attachments.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final note = NoteModel(
      id: widget.note?.id,
      title: title.isEmpty ? 'Untitled' : title,
      content: content,
      color: _selectedColor,
      isPinned: _isPinned,
      isArchived: widget.note?.isArchived ?? false,
      isLocked: _isLocked,
      attachments: _attachments,
      category: _selectedCategory,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
    );

    if (widget.note == null) {
      context.read<NotesCubit>().addNote(note);
    } else {
      context.read<NotesCubit>().updateNote(note);
    }
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final savedPath = await FileService.saveAttachment(File(image.path));
      if (!mounted) return;
      setState(() => _attachments.add(savedPath));
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final savedPath = await FileService.saveAttachment(File(result.files.single.path!));
      if (!mounted) {
        return;
      }
      setState(() => _attachments.add(savedPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!_isDirty) {
          Navigator.pop(context);
          return;
        }
        final save = await showDialog<bool>(context: context, builder: (c) => const ExitConfirmationDialog());
        if (save == null) return;
        if (save) {
          _saveNote();
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Color(_selectedColor),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                children: [
                  AttachmentsBar(
                    attachments: _attachments,
                    onRemoveAttachment: (index) => setState(() => _attachments.removeAt(index)),
                  ),
                  _buildTitleField(),
                  const SizedBox(height: 8),
                  _buildCategoryPicker(),
                  const SizedBox(height: 16),
                  _buildContentField(),
                ],
              ),
            ),
            EditorBottomPanel(
              selectedColor: _selectedColor,
              colors: _colors,
              onColorSelected: (color) => setState(() => _selectedColor = color),
              onPickImage: _pickImage,
              onPickFile: _pickFile,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_outlined),
          onPressed: () => PdfService.exportNote(NoteModel(
            title: _titleController.text,
            content: _contentController.text,
            color: _selectedColor,
            category: _selectedCategory,
            attachments: _attachments,
            createdAt: widget.note?.createdAt ?? DateTime.now(),
          )),
          tooltip: 'Export to PDF',
        ),
        IconButton(
          icon: Icon(_isLocked ? Icons.lock_rounded : Icons.lock_open_rounded),
          onPressed: () => setState(() => _isLocked = !_isLocked),
          tooltip: 'Lock Note',
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            builder: (c) => NoteInfoSheet(note: widget.note, content: _contentController.text),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () => sp.Share.share("${_titleController.text}\n\n${_contentController.text}"),
        ),
        IconButton(
          icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
          onPressed: () => setState(() => _isPinned = !_isPinned),
        ),
        IconButton(
          icon: const Icon(Icons.check, size: 28),
          onPressed: _saveNote,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
      decoration: const InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black38),
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87, height: 1.6),
      maxLines: null,
      decoration: const InputDecoration(
        hintText: 'Start typing...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black38),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state is! NotesLoaded) return const SizedBox.shrink();
        return Wrap(
          spacing: 8,
          children: state.categories.map((cat) {
            final isSelected = _selectedCategory == cat.name;
            return ChoiceChip(
              label: Text(cat.name),
              selected: isSelected,
              onSelected: (selected) => setState(() => _selectedCategory = selected ? cat.name : null),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            );
          }).toList(),
        );
      },
    );
  }
}
