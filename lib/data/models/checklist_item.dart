class ChecklistItem {
  String text;
  bool isDone;

  ChecklistItem({
    required this.text,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() => {
        'text': text,
        'isDone': isDone,
      };

  factory ChecklistItem.fromMap(Map<String, dynamic> map) => ChecklistItem(
        text: map['text'] ?? '',
        isDone: map['isDone'] ?? false,
      );
}
