import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/note_model.dart';
import '../../../logic/notes_cubit/notes_state.dart';
import '../note_card.dart';

class NotesView extends StatelessWidget {
  final NotesLoaded state;
  final Function(NoteModel) onNoteTap;
  final Function(NoteModel) onNoteLongPress;

  const NotesView({
    super.key,
    required this.state,
    required this.onNoteTap,
    required this.onNoteLongPress,
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: () => onNoteTap(notes[index]),
            onLongPress: () => onNoteLongPress(notes[index]),
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
              onTap: () => onNoteTap(notes[index]),
              onLongPress: () => onNoteLongPress(notes[index]),
            ),
            childCount: notes.length,
          ),
        ),
      );
    }
  }
}
