import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/notes_cubit/notes_cubit.dart';
import '../../logic/notes_cubit/notes_state.dart';
import '../pages/category_manager_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF0F4F8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          final bool isArchived = state is NotesLoaded && state.isShowingArchived;
          final bool isTrash = state is NotesLoaded && state.isShowingTrash;
          final bool isNotes = !isArchived && !isTrash;

          return Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0061A4), Color(0xFF00A3FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.note_alt_rounded, color: Colors.white, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'MyNote Pro',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _drawerItem(
                context,
                icon: Icons.notes_rounded,
                label: 'All Notes',
                isSelected: isNotes,
                onTap: () {
                  context.read<NotesCubit>().loadNotes(showArchived: false, showTrash: false);
                  Navigator.pop(context);
                },
              ),
              _drawerItem(
                context,
                icon: Icons.archive_outlined,
                label: 'Archive',
                isSelected: isArchived,
                onTap: () {
                  context.read<NotesCubit>().loadNotes(showArchived: true, showTrash: false);
                  Navigator.pop(context);
                },
              ),
              _drawerItem(
                context,
                icon: Icons.delete_outline_rounded,
                label: 'Trash',
                isSelected: isTrash,
                onTap: () {
                  context.read<NotesCubit>().loadNotes(showTrash: true, showArchived: false);
                  Navigator.pop(context);
                },
              ),
              const Divider(indent: 20, endIndent: 20, height: 40),
              _drawerItem(
                context,
                icon: Icons.category_outlined,
                label: 'Manage Categories',
                isSelected: false,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryManagerPage()));
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'v1.2.0 - 100% Local Privacy',
                  style: TextStyle(color: Colors.black.withValues(alpha: 0.4), fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _drawerItem(BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        tileColor: isSelected ? const Color(0xFF0061A4) : Colors.transparent,
      ),
    );
  }
}
