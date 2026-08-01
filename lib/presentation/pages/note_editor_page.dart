import 'dart:io';
import 'dart:convert';
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
import 'package:mynote/logic/services/audio_service.dart';
import '../../logic/services/markdown_text_controller.dart';
import '../../logic/services/pdf_service.dart';
import '../../logic/l10n/app_localizations.dart';
import '../widgets/editor/formatting_toolbar.dart';
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

class _ChecklistItem {
  String text;
  bool isDone;
  _ChecklistItem({required this.text, this.isDone = false});

  Map<String, dynamic> toMap() => {'text': text, 'isDone': isDone};
  factory _ChecklistItem.fromMap(Map<String, dynamic> map) =>
      _ChecklistItem(text: map['text'], isDone: map['isDone']);
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedColor;
  late bool _isPinned;
  late bool _isLocked;
  late bool _isChecklist;
  bool _isRecording = false;
  String? _selectedCategory;
  List<String> _attachments = [];
  List<_ChecklistItem> _checklistItems = [];

  final List<int> _colors = [
    0xFFFFFFFF, 0xFFF28B82, 0xFFFBBC04, 0xFFFFF475,
    0xFFCCFF90, 0xFFA7FFEB, 0xFFCBF0F8, 0xFFAECBFA,
    0xFFD7AEFB, 0xFFFDCFE8, 0xFFE6C9A8, 0xFFE8EAED,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        MarkdownTextController()..text = widget.note?.content ?? '';
    _selectedColor = widget.note?.color ?? _colors[0];
    _isPinned = widget.note?.isPinned ?? false;
    _isLocked = widget.note?.isLocked ?? false;
    _isChecklist = widget.note?.isChecklist ?? false;
    _selectedCategory = widget.note?.category;
    _attachments = List.from(widget.note?.attachments ?? []);

    if (_isChecklist && widget.note?.content != null) {
      try {
        final List<dynamic> decoded = jsonDecode(widget.note!.content);
        _checklistItems =
            decoded.map((e) => _ChecklistItem.fromMap(e)).toList();
      } catch (e) {
        _checklistItems = [_ChecklistItem(text: widget.note!.content)];
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final title = _titleController.text.trim();
    final content = _isChecklist
        ? jsonEncode(_checklistItems.map((e) => e.toMap()).toList())
        : _contentController.text.trim();

    if (widget.note == null) {
      return title.isNotEmpty ||
          content.isNotEmpty ||
          _attachments.isNotEmpty ||
          _checklistItems.isNotEmpty;
    }

    return title != widget.note!.title ||
        content != widget.note!.content ||
        _selectedColor != widget.note!.color ||
        _isPinned != widget.note!.isPinned ||
        _isLocked != widget.note!.isLocked ||
        _isChecklist != widget.note!.isChecklist ||
        _selectedCategory != widget.note!.category ||
        _attachments.length != widget.note!.attachments.length;
  }

  Color get _contentColor {
    return ThemeData.estimateBrightnessForColor(Color(_selectedColor)) == Brightness.light
        ? const Color(0xFF001E30)
        : Colors.white;
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _isChecklist
        ? jsonEncode(_checklistItems.map((e) => e.toMap()).toList())
        : _contentController.text.trim();

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
      isChecklist: _isChecklist,
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

  void _toggleChecklist() {
    setState(() {
      _isChecklist = !_isChecklist;
      if (_isChecklist) {
        final lines =
            _contentController.text.split('\n').where((l) => l.trim().isNotEmpty);
        if (lines.isNotEmpty) {
          _checklistItems = lines.map((l) => _ChecklistItem(text: l)).toList();
        } else if (_checklistItems.isEmpty) {
          _checklistItems = [_ChecklistItem(text: '')];
        }
      } else {
        _contentController.text = _checklistItems.map((e) => e.text).join('\n');
      }
    });
  }

  Future<void> _handleMic() async {
    if (_isRecording) {
      final path = await AudioService.stopRecording();
      setState(() {
        _isRecording = false;
        if (path != null) _attachments.add(path);
      });
    } else {
      final started = await AudioService.startRecording();
      if (started) {
        setState(() => _isRecording = true);
      }
    }
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
      final savedPath =
          await FileService.saveAttachment(File(result.files.single.path!));
      if (!mounted) return;
      setState(() => _attachments.add(savedPath));
    }
  }

  void _formatText(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid && selection.baseOffset >= 0) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(
          selection.start, selection.end, '$prefix$selectedText$suffix');
      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(
          offset: selection.start +
              prefix.length +
              selectedText.length +
              suffix.length);
    } else {
      final newText = '$text$prefix$suffix';
      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(offset: newText.length - suffix.length);
    }
  }

  void _addBullet() {
    final text = _contentController.text;
    final selection = _contentController.selection;
    
    if (selection.isValid && selection.baseOffset >= 0) {
      final currentPos = selection.baseOffset;
      final newText = text.replaceRange(currentPos, currentPos, '\n• ');
      _contentController.text = newText;
      _contentController.selection =
          TextSelection.collapsed(offset: currentPos + 3);
    } else {
      final newText = '$text\n• ';
      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(offset: newText.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!_isDirty) {
          navigator.pop();
          return;
        }
        final save = await showDialog<bool>(
            context: context, builder: (c) => const ExitConfirmationDialog());
        if (save == null) return;
        if (save) {
          _saveNote();
        } else {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Color(_selectedColor),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                children: [
                  AttachmentsBar(
                    attachments: _attachments,
                    onRemoveAttachment: (index) =>
                        setState(() => _attachments.removeAt(index)),
                  ),
                  _buildTitleField(),
                  const SizedBox(height: 8),
                  _buildCategoryPicker(),
                  const SizedBox(height: 16),
                  if (_isChecklist)
                    _buildChecklistEditor()
                  else
                    _buildContentField(),
                ],
              ),
            ),
            FormattingToolbar(
              onBold: () => _formatText('**', '**'),
              onItalic: () => _formatText('*', '*'),
              onBullet: _addBullet,
              onChecklist: _toggleChecklist,
              onMic: _handleMic,
              isRecording: _isRecording,
              isChecklist: _isChecklist,
            ),
            EditorBottomPanel(
              selectedColor: _selectedColor,
              colors: _colors,
              onColorSelected: (color) => setState(() => _selectedColor = color),
              onPickImage: _pickImage,
              onPickFile: _pickFile,
              contentColor: _contentColor,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context);
    final contentColor = _contentColor;
    
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: contentColor),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_outlined),
          color: contentColor,
          onPressed: () => PdfService.exportNote(NoteModel(
            title: _titleController.text,
            content: _isChecklist
                ? jsonEncode(_checklistItems.map((e) => e.toMap()).toList())
                : _contentController.text,
            color: _selectedColor,
            category: _selectedCategory,
            attachments: _attachments,
            isChecklist: _isChecklist,
            createdAt: widget.note?.createdAt ?? DateTime.now(),
          )),
          tooltip: l10n.translate('export_pdf'),
        ),
        IconButton(
          icon: Icon(_isLocked ? Icons.lock_rounded : Icons.lock_open_rounded),
          color: contentColor,
          onPressed: () => setState(() => _isLocked = !_isLocked),
          tooltip: l10n.translate('lock_note'),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          color: contentColor,
          onPressed: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            builder: (c) => NoteInfoSheet(
                note: widget.note, content: _contentController.text),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          color: contentColor,
          onPressed: () {
            sp.Share.share(
                "${_titleController.text}\n\n${_contentController.text}");
          },
        ),
        IconButton(
          icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
          color: contentColor,
          onPressed: () => setState(() => _isPinned = !_isPinned),
        ),
        IconButton(
          icon: const Icon(Icons.check, size: 28),
          color: contentColor,
          onPressed: _saveNote,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTitleField() {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _titleController,
      textAlign: TextAlign.start,
      style: GoogleFonts.poppins(
          fontSize: 28, fontWeight: FontWeight.bold, color: _contentColor),
      decoration: InputDecoration(
        hintText: l10n.translate('title_hint'),
        border: InputBorder.none,
        hintStyle: TextStyle(color: _contentColor.withValues(alpha: 0.4)),
      ),
    );
  }

  Widget _buildContentField() {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _contentController,
      textAlign: TextAlign.start,
      style: GoogleFonts.poppins(
          fontSize: 18, color: _contentColor, height: 1.6),
      maxLines: null,
      decoration: InputDecoration(
        hintText: l10n.translate('content_hint'),
        border: InputBorder.none,
        hintStyle: TextStyle(color: _contentColor.withValues(alpha: 0.4)),
      ),
    );
  }

  Widget _buildChecklistEditor() {
    final l10n = AppLocalizations.of(context);
    final contentColor = _contentColor;

    return Column(
      children: [
        ..._checklistItems.asMap().entries.map((entry) {
          int idx = entry.key;
          _ChecklistItem item = entry.value;
          return Row(
            children: [
              Checkbox(
                value: item.isDone,
                onChanged: (val) => setState(() => item.isDone = val!),
                activeColor: const Color(0xFF0061A4),
                side: BorderSide(color: contentColor.withValues(alpha: 0.5)),
              ),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: item.text)
                    ..selection = TextSelection.fromPosition(
                        TextPosition(offset: item.text.length)),
                  onChanged: (val) => item.text = val,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    decoration: item.isDone ? TextDecoration.lineThrough : null,
                    color: item.isDone ? contentColor.withValues(alpha: 0.4) : contentColor,
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                  onSubmitted: (_) {
                    setState(() => _checklistItems.insert(
                        idx + 1, _ChecklistItem(text: '')));
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20, color: contentColor.withValues(alpha: 0.3)),
                onPressed: () => setState(() => _checklistItems.removeAt(idx)),
              ),
            ],
          );
        }),
        TextButton.icon(
          onPressed: () =>
              setState(() => _checklistItems.add(_ChecklistItem(text: ''))),
          icon: Icon(Icons.add, color: contentColor),
          label: Text(l10n.translate('add_item'), style: TextStyle(color: contentColor)),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker() {
    final contentColor = _contentColor;
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state is! NotesLoaded) return const SizedBox.shrink();
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: state.categories.map((cat) {
            final isSelected = _selectedCategory == cat.name;
            return ChoiceChip(
              label: Text(cat.name),
              selected: isSelected,
              onSelected: (selected) =>
                  setState(() => _selectedCategory = selected ? cat.name : null),
              selectedColor: const Color(0xFF0061A4),
              backgroundColor: contentColor.withValues(alpha: 0.05),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : contentColor.withValues(alpha: 0.8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              side: BorderSide(
                color: isSelected ? const Color(0xFF001E30) : contentColor.withValues(alpha: 0.1),
                width: isSelected ? 2.5 : 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              showCheckmark: isSelected,
              checkmarkColor: Colors.white,
              elevation: isSelected ? 4 : 0,
              pressElevation: 8,
            );
          }).toList(),
        );
      },
    );
  }
}
