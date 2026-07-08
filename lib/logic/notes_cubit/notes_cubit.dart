import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/database/sqldb.dart';
import '../../data/models/note_model.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final SqlDb sqlDb;

  NotesCubit(this.sqlDb) : super(NotesInitial());

  Future<void> loadNotes() async {
    emit(NotesLoading());
    try {
      final notes = await sqlDb.readAllNotes();
      emit(NotesLoaded(notes));
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
    if (query.isEmpty) {
      loadNotes();
      return;
    }
    emit(NotesLoading());
    try {
      final notes = await sqlDb.searchNotes(query);
      emit(NotesLoaded(notes, searchQuery: query));
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
