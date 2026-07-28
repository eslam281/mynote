import 'package:flutter/material.dart';
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
    if (state.isShowingArchived || state.isShowingTrash) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final categories = ['All', ...state.categories.map((c) => c.name)];

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
                  label: const Text('Add'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CategoryManagerPage()),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.white,
                ),
              );
            }
            final category = categories[index];
            final isSelected = (state.selectedCategory ?? 'All') == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onCategorySelected(category == 'All' ? null : category);
                  }
                },
                selectedColor: const Color(0xFF0061A4),
                backgroundColor: Colors.white,
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
