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
  final bool isGridView;
  final String? selectedCategory;
  final bool isShowingArchived;

  const NotesLoaded(
    this.notes, {
    this.searchQuery,
    this.isGridView = true,
    this.selectedCategory,
    this.isShowingArchived = false,
  });

  @override
  List<Object?> get props => [notes, searchQuery, isGridView, selectedCategory, isShowingArchived];

  NotesLoaded copyWith({
    List<NoteModel>? notes,
    String? searchQuery,
    bool? isGridView,
    String? selectedCategory,
    bool? isShowingArchived,
  }) {
    return NotesLoaded(
      notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
      isGridView: isGridView ?? this.isGridView,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isShowingArchived: isShowingArchived ?? this.isShowingArchived,
    );
  }
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}
