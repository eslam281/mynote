import 'package:equatable/equatable.dart';
import '../../data/models/note_model.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteModel> notes;
  final String? searchQuery;

  const NotesLoaded(this.notes, {this.searchQuery});

  @override
  List<Object?> get props => [notes, searchQuery];
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}
