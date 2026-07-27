import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/models/note_model.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../../logic/notes_cubit/notes_state.dart';
import '../../logic/services/file_service.dart';
import '../../logic/services/pdf_service.dart';

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
    0xFFFFFFFF, // White
    0xFFF28B82, // Red
    0xFFFBBC04, // Orange/Yellow
    0xFFFFF475, // Yellow
    0xFFCCFF90, // Green
    0xFFA7FFEB, // Teal
    0xFFCBF0F8, // Blue
    0xFFAECBFA, // Dark Blue
    0xFFD7AEFB, // Purple
    0xFFFDCFE8, // Pink
    0xFFE6C9A8, // Brown
    0xFFE8EAED, // Gray
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
      setState(() {
        _attachments.add(savedPath);
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final savedPath = await FileService.saveAttachment(File(result.files.single.path!));
      setState(() {
        _attachments.add(savedPath);
      });
    }
  }

  void _shareNote() {
    final text = "${_titleController.text}\n\n${_contentController.text}";
    Share.share(text);
  }

  void _showNoteInfo() {
    final content = _contentController.text;
    final words = content.trim().isEmpty ? 0 : content.trim().split(RegExp(r'\s+')).length;
    final chars = content.length;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Note Info', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _infoRow(Icons.text_fields, 'Characters', chars.toString()),
            _infoRow(Icons.short_text, 'Words', words.toString()),
            _infoRow(Icons.calendar_today, 'Created', DateFormat('MMM dd, yyyy HH:mm').format(widget.note?.createdAt ?? DateTime.now())),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(_selectedColor),
      appBar: AppBar(
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
            onPressed: _showNoteInfo,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: _shareNote,
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              children: [
                if (_attachments.isNotEmpty) _buildAttachmentsList(),
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black38),
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, state) {
                    if (state is! NotesLoaded) return const SizedBox.shrink();
                    return Wrap(
                      spacing: 8,
                      children: state.categories.map((cat) {
                        final isSelected = _selectedCategory == cat.name;
                        return ChoiceChip(
                          label: Text(cat.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? cat.name : null;
                            });
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87, height: 1.6),
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black38),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildAttachmentsList() {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _attachments.length,
        itemBuilder: (context, index) {
          final path = _attachments[index];
          final isImage = path.toLowerCase().endsWith('.jpg') || path.toLowerCase().endsWith('.png') || path.toLowerCase().endsWith('.jpeg');

          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withValues(alpha: 0.05),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isImage)
                  Image.file(File(path), fit: BoxFit.cover)
                else
                  const Center(child: Icon(Icons.insert_drive_file_rounded, size: 32, color: Colors.black45)),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => setState(() => _attachments.removeAt(index)),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.image_outlined), onPressed: _pickImage),
              IconButton(icon: const Icon(Icons.attach_file_rounded), onPressed: _pickFile),
              const Spacer(),
              const Text('Background Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                final colorValue = _colors[index];
                final isSelected = _selectedColor == colorValue;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = colorValue),
                  child: Container(
                    width: 45,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Color(colorValue),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black87 : Colors.black12,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected ? const Icon(Icons.check, size: 20) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
