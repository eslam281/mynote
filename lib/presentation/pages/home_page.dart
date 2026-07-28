import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_model.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../../logic/notes_cubit/notes_state.dart';
import '../../logic/services/auth_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/category_selector.dart';
import '../widgets/home/notes_view.dart';
import '../widgets/home/trash_reminder.dart';
import '../widgets/common/confirmation_dialogs.dart';
import '../widgets/common/custom_bottom_sheets.dart';
import 'note_editor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is! NotesLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              HomeAppBar(
                state: state,
                searchController: _searchController,
                onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                onToggleViewMode: () => context.read<NotesCubit>().toggleViewMode(),
                onDeleteAll: _showDeleteAllDialog,
                onSearchChanged: (query) => context.read<NotesCubit>().searchNotes(query),
              ),
              if (state.isShowingTrash) const TrashReminder(),
              CategorySelector(
                state: state,
                onCategorySelected: (category) => context.read<NotesCubit>().filterByCategory(category),
              ),
              NotesView(
                state: state,
                onNoteTap: _handleNoteTap,
                onNoteLongPress: _showNoteOptions,
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0061A4), Color(0xFF00A3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0061A4).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteEditorPage())),
        label: const Text('New Note', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Future<void> _handleNoteTap(NoteModel note) async {
    if (_isAuthenticating) return;
    
    if (note.isLocked) {
      setState(() => _isAuthenticating = true);
      final authenticated = await AuthService.authenticate();
      if (!mounted) return;
      setState(() => _isAuthenticating = false);
      if (!authenticated) return;
    }
    
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorPage(note: note)));
  }

  void _showNoteOptions(NoteModel note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => NoteOptionsSheet(
        note: note,
        onTogglePin: (n) => context.read<NotesCubit>().togglePin(n),
        onToggleArchive: (n) => context.read<NotesCubit>().toggleArchive(n),
        onSoftDelete: (n) => context.read<NotesCubit>().softDeleteNote(n),
        onRestore: (n) => context.read<NotesCubit>().restoreNote(n),
        onDeletePermanently: (id) => context.read<NotesCubit>().deleteNotePermanently(id),
        onDuplicate: (n) => context.read<NotesCubit>().duplicateNote(n),
      ),
    );
  }

  void _showDeleteAllDialog() async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAllConfirmationDialog(),
    );
    if (delete == true && mounted) {
      context.read<NotesCubit>().deleteAllNotes();
    }
  }
}
