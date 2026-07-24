import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int? id;
  final String name;
  final int color;

  const CategoryModel({
    this.id,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: map['color'] as int,
    );
  }

  @override
  List<Object?> get props => [id, name, color];
}
