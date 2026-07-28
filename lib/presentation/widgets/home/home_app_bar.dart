import 'package:flutter/material.dart';
import '../../../logic/notes_cubit/notes_state.dart';

class HomeAppBar extends StatelessWidget {
  final NotesLoaded state;
  final TextEditingController searchController;
  final VoidCallback onOpenDrawer;
  final VoidCallback onToggleViewMode;
  final VoidCallback onDeleteAll;
  final Function(String) onSearchChanged;

  const HomeAppBar({
    super.key,
    required this.state,
    required this.searchController,
    required this.onOpenDrawer,
    required this.onToggleViewMode,
    required this.onDeleteAll,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    String title = 'My Notes';
    if (state.isShowingTrash) {
      title = 'Trash';
    } else if (state.isShowingArchived) {
      title = 'Archive';
    }

    return SliverAppBar.large(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: onOpenDrawer,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF0F4F8), Color(0xFFE0E8F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(state.isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
          onPressed: onToggleViewMode,
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete_all') {
              onDeleteAll();
            }
          },
          itemBuilder: (context) => [
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
            controller: searchController,
            hintText: 'Search your notes...',
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.05)),
            leading: const Icon(Icons.search, color: Colors.black54),
            trailing: [
              if (searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    searchController.clear();
                    onSearchChanged('');
                  },
                )
            ],
            onChanged: onSearchChanged,
          ),
        ),
      ),
    );
  }
}
