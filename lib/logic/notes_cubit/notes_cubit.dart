import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/database/sqldb.dart';
import '../../data/models/note_model.dart';
import '../../data/models/category_model.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final SqlDb sqlDb;

  NotesCubit(this.sqlDb) : super(NotesInitial());

  Future<void> loadNotes({bool? showArchived, bool? showTrash}) async {
    final currentState = state;
    bool showingArchived = showArchived ?? (currentState is NotesLoaded ? currentState.isShowingArchived : false);
    bool showingTrash = showTrash ?? (currentState is NotesLoaded ? currentState.isShowingTrash : false);
    
    if (currentState is! NotesLoaded) {
      emit(NotesLoading());
    }

    try {
      final categories = await sqlDb.readAllCategories();
      List<NoteModel> notes;
      
      if (showingTrash) {
        notes = await sqlDb.readDeletedNotes();
      } else if (showingArchived) {
        notes = await sqlDb.readArchivedNotes();
      } else {
        notes = await sqlDb.readAllNotes();
      }
      
      if (currentState is NotesLoaded) {
        emit(currentState.copyWith(
          notes: notes, 
          categories: categories,
          isShowingArchived: showingArchived, 
          isShowingTrash: showingTrash
        ));
      } else {
        emit(NotesLoaded(
          notes, 
          categories: categories,
          isShowingArchived: showingArchived, 
          isShowingTrash: showingTrash
        ));
      }
    } catch (e) {
      emit(NotesError(e.toString()));
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

  Future<void> softDeleteNote(NoteModel note) async {
    final updatedNote = note.copyWith(
      isDeleted: true, 
      deletedAt: () => DateTime.now(),
      isPinned: false
    );
    await updateNote(updatedNote);
  }

  Future<void> restoreNote(NoteModel note) async {
    final updatedNote = note.copyWith(
      isDeleted: false, 
      deletedAt: () => null
    );
    await updateNote(updatedNote);
  }

  Future<void> deleteNotePermanently(int id) async {
    try {
      await sqlDb.deleteNote(id);
      loadNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> duplicateNote(NoteModel note) async {
    final newNote = note.copyWith(
      id: null,
      title: "${note.title} (Copy)",
      createdAt: DateTime.now()
    );
    await addNote(newNote);
  }

  // Category Methods
  Future<void> addCategory(String name, int color) async {
    try {
      await sqlDb.insertCategory(CategoryModel(name: name, color: color));
      loadNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await sqlDb.deleteCategory(id);
      loadNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
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
      emit(currentState.copyWith(selectedCategory: () => category));
      loadNotes(); 
    }
  }

  Future<void> togglePin(NoteModel note) async {
    final updatedNote = note.copyWith(isPinned: !note.isPinned);
    await updateNote(updatedNote);
  }

  Future<void> toggleArchive(NoteModel note) async {
    final updatedNote = note.copyWith(isArchived: !note.isArchived);
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
