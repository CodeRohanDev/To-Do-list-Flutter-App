import 'dart:convert';

class Task {
  final String title;
  final int priority;
  bool isCompleted;

  Task({
    required this.title,
    required this.priority,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      priority: json['priority'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}
