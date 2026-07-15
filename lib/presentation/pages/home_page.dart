import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../../logic/notes_cubit/notes_state.dart';
import '../widgets/note_card.dart';
import 'note_editor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Work', 'Personal', 'Ideas', 'Important'];

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
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context, state),
              _buildCategorySelector(context, state),
              _buildNotesContent(context, state),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteEditorPage()),
          );
        },
        label: const Text('New Note', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, NotesState state) {
    final bool isArchivedView = state is NotesLoaded && state.isShowingArchived;
    
    return SliverAppBar.large(
      title: Text(isArchivedView ? 'Archive' : 'My Notes'),
      actions: [
        IconButton(
          icon: Icon(state is NotesLoaded && state.isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
          onPressed: () => context.read<NotesCubit>().toggleViewMode(),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete_all') {
              _showDeleteAllDialog();
            } else if (value == 'toggle_archive') {
              context.read<NotesCubit>().loadNotes(showArchived: !isArchivedView);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle_archive',
              child: Text(isArchivedView ? 'Show All Notes' : 'Show Archive'),
            ),
            const PopupMenuItem(
              value: 'delete_all',
              child: Text('Delete all notes', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SearchBar(
            controller: _searchController,
            hintText: 'Search your notes...',
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.05)),
            leading: const Icon(Icons.search, color: Colors.black54),
            trailing: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    context.read<NotesCubit>().searchNotes('');
                  },
                )
            ],
            onChanged: (value) => context.read<NotesCubit>().searchNotes(value),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, NotesState state) {
    if (state is! NotesLoaded || state.isShowingArchived) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = (state.selectedCategory ?? 'All') == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  context.read<NotesCubit>().filterByCategory(category == 'All' ? null : category);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotesContent(BuildContext context, NotesState state) {
    if (state is NotesLoading) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }

    if (state is NotesLoaded) {
      var notes = state.notes;
      if (state.selectedCategory != null) {
        notes = notes.where((n) => n.category == state.selectedCategory).toList();
      }

      if (notes.isEmpty) {
        return SliverFillRemaining(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notes_rounded, size: 80, color: Colors.grey.shade300)
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2.seconds, color: Colors.white)
                  .shake(hz: 2, curve: Curves.easeInOut),
              const SizedBox(height: 16),
              Text(
                'No notes found',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }

      if (state.isGridView) {
        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemBuilder: (context, index) => NoteCard(
              note: notes[index],
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorPage(note: notes[index]))),
              onLongPress: () => _showNoteOptions(notes[index]),
            ),
            childCount: notes.length,
          ),
        );
      } else {
        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => NoteCard(
                note: notes[index],
                isListMode: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorPage(note: notes[index]))),
                onLongPress: () => _showNoteOptions(notes[index]),
              ),
              childCount: notes.length,
            ),
          ),
        );
      }
    }

    return const SliverFillRemaining(child: SizedBox.shrink());
  }

  void _showNoteOptions(note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.isPinned ? 'Unpin' : 'Pin'),
              onTap: () {
                this.context.read<NotesCubit>().togglePin(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(note.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined),
              title: Text(note.isArchived ? 'Unarchive' : 'Archive'),
              onTap: () {
                this.context.read<NotesCubit>().toggleArchive(note);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                this.context.read<NotesCubit>().deleteNote(note.id!);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete all notes?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              this.context.read<NotesCubit>().deleteAllNotes();
              Navigator.pop(context);
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
