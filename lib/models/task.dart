// models/task.dart
class Task {
  String title;
  String note;
  int priority;
  bool isCompleted;
  DateTime? timestamp; // Add timestamp field

  Task({
    required this.title,
    this.note = '',
    required this.priority,
    this.isCompleted = false,
    this.timestamp, // Initialize timestamp field
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'note': note,
        'priority': priority,
        'isCompleted': isCompleted,
        'timestamp': timestamp?.toIso8601String(), // Encode timestamp
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        note: json['note'] ?? '',
        priority: json['priority'],
        isCompleted: json['isCompleted'],
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp']) // Decode timestamp
            : null,
      );
}
