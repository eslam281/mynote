import 'package:equatable/equatable.dart';
import '../../data/models/note_model.dart';
import '../../data/models/category_model.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteModel> notes;
  final List<CategoryModel> categories;
  final String? searchQuery;
  final bool isGridView;
  final String? selectedCategory;
  final bool isShowingArchived;
  final bool isShowingTrash;

  const NotesLoaded(
    this.notes, {
    this.categories = const [],
    this.searchQuery,
    this.isGridView = true,
    this.selectedCategory,
    this.isShowingArchived = false,
    this.isShowingTrash = false,
  });

  @override
  List<Object?> get props => [notes, categories, searchQuery, isGridView, selectedCategory, isShowingArchived, isShowingTrash];

  NotesLoaded copyWith({
    List<NoteModel>? notes,
    List<CategoryModel>? categories,
    String? searchQuery,
    bool? isGridView,
    String? Function()? selectedCategory,
    bool? isShowingArchived,
    bool? isShowingTrash,
  }) {
    return NotesLoaded(
      notes ?? this.notes,
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      isGridView: isGridView ?? this.isGridView,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      isShowingArchived: isShowingArchived ?? this.isShowingArchived,
      isShowingTrash: isShowingTrash ?? this.isShowingTrash,
    );
  }
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}
