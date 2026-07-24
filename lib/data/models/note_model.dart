import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  final int? id;
  final String title;
  final String content;
  final int color;
  final bool isPinned;
  final bool isArchived;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? category;
  final DateTime createdAt;

  const NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    this.isPinned = false,
    this.isArchived = false,
    this.isDeleted = false,
    this.deletedAt,
    this.category,
    required this.createdAt,
  });

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    int? color,
    bool? isPinned,
    bool? isArchived,
    bool? isDeleted,
    DateTime? Function()? deletedAt,
    String? Function()? category,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt != null ? deletedAt() : this.deletedAt,
      category: category != null ? category() : this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'isPinned': isPinned ? 1 : 0,
      'isArchived': isArchived ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
      'deletedAt': deletedAt?.toIso8601String(),
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as int,
      isPinned: (map['isPinned'] as int) == 1,
      isArchived: (map['isArchived'] ?? 0) == 1,
      isDeleted: (map['isDeleted'] ?? 0) == 1,
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt'] as String) : null,
      category: map['category'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, title, content, color, isPinned, isArchived, isDeleted, deletedAt, category, createdAt];
}
