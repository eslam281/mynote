import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/database/sqldb.dart';
import '../../data/models/note_model.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final SqlDb sqlDb;

  NotesCubit(this.sqlDb) : super(NotesInitial());

  Future<void> loadNotes({bool? showArchived}) async {
    final currentState = state;
    bool showingArchived = showArchived ?? (currentState is NotesLoaded ? currentState.isShowingArchived : false);
    
    // Use "silent loading" if we already have notes to avoid full screen spinner
    if (currentState is! NotesLoaded) {
      emit(NotesLoading());
    }

    try {
      final notes = showingArchived 
          ? await sqlDb.readArchivedNotes()
          : await sqlDb.readAllNotes();
      
      if (currentState is NotesLoaded) {
        emit(currentState.copyWith(notes: notes, isShowingArchived: showingArchived));
      } else {
        emit(NotesLoaded(notes, isShowingArchived: showingArchived));
      }
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> toggleArchive(NoteModel note) async {
    final updatedNote = note.copyWith(isArchived: !note.isArchived);
    await updateNote(updatedNote);
  }

  void toggleViewMode() {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      emit(currentState.copyWith(isGridView: !currentState.isGridView));
    }
  }

  Future<void> filterByCategory(String? category) async {
    if (state is NotesLoaded) {
      final currentState = state as NotesLoaded;
      emit(currentState.copyWith(selectedCategory: category));
      // Re-load with category filter if implemented in DB, 
      // otherwise we can filter in memory for small datasets.
      // For performance, let's filter in memory first.
      loadNotes(); 
    }
  }

  Future<void> addNote(NoteModel note) async {
    try {
      await sqlDb.insertNote(note);
      loadNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await sqlDb.updateNote(note);
      loadNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await sqlDb.deleteNote(id);
      loadNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> togglePin(NoteModel note) async {
    final updatedNote = note.copyWith(isPinned: !note.isPinned);
    await updateNote(updatedNote);
  }

  Future<void> searchNotes(String query) async {
    final currentState = state;
    bool isShowingArchived = currentState is NotesLoaded ? currentState.isShowingArchived : false;

    if (query.isEmpty) {
      loadNotes(showArchived: isShowingArchived);
      return;
    }

    try {
      final notes = await sqlDb.searchNotes(query, includeArchived: isShowingArchived);
      if (currentState is NotesLoaded) {
        emit(currentState.copyWith(notes: notes, searchQuery: query));
      } else {
        emit(NotesLoaded(notes, searchQuery: query, isShowingArchived: isShowingArchived));
      }
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteAllNotes() async {
    try {
      await sqlDb.deleteAllNotes();
      loadNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
