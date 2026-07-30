import 'package:flutter/material.dart';
import '../../../logic/l10n/app_localizations.dart';
import '../../../logic/notes_cubit/notes_state.dart';
import '../../pages/category_manager_page.dart';

class CategorySelector extends StatelessWidget {
  final NotesLoaded state;
  final Function(String?) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.state,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state.isShowingArchived || state.isShowingTrash) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final categories = [l10n.translate('all'), ...state.categories.map((c) => c.name)];

    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == categories.length) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.translate('add')),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CategoryManagerPage()),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                ),
              );
            }
            final category = categories[index];
            final isSelected = (state.selectedCategory ?? l10n.translate('all')) == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onCategorySelected(category == l10n.translate('all') ? null : category);
                  }
                },
                selectedColor: const Color(0xFF0061A4),
                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                showCheckmark: false,
                elevation: isSelected ? 4 : 0,
              ),
            );
          },
        ),
      ),
    );
  }
}
