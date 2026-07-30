import 'package:flutter/material.dart';
import '../../../logic/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String title = l10n.translate('home');
    if (state.isShowingTrash) {
      title = l10n.translate('trash');
    } else if (state.isShowingArchived) {
      title = l10n.translate('archive');
    }

    return SliverAppBar.large(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: onOpenDrawer,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark 
                ? [const Color(0xFF121212), const Color(0xFF1E1E1E)]
                : [const Color(0xFFF0F4F8), const Color(0xFFE0E8F0)],
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
            PopupMenuItem(
              value: 'delete_all',
              child: Text(l10n.translate('delete_all'), style: const TextStyle(color: Colors.red)),
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
            hintText: l10n.translate('search_hint'),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
              isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)
            ),
            leading: Icon(Icons.search, color: isDark ? Colors.white54 : Colors.black54),
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
