class Task {
  final String title;
  final int priority;
  bool isCompleted;
  String note;

  Task({
    required this.title,
    required this.priority,
    this.isCompleted = false,
    this.note = '',
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      priority: json['priority'],
      isCompleted: json['isCompleted'],
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'isCompleted': isCompleted,
      'note': note,
    };
  }
}
