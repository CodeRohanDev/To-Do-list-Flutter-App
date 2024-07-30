class Task {
  final String title;
  final String note;
  final int priority;
  final DateTime? timestamp;
  bool isCompleted;
  bool isMissed;

  Task({
    required this.title,
    required this.note,
    required this.priority,
    this.timestamp,
    this.isCompleted = false,
    this.isMissed = false,
  });

  // Method to get the formatted timestamp
  String getFormattedTimestamp() {
    if (timestamp == null) return '';
    final year = timestamp!.year.toString().padLeft(4, '0');
    final month = timestamp!.month.toString().padLeft(2, '0');
    final day = timestamp!.day.toString().padLeft(2, '0');
    final hour = timestamp!.hour.toString().padLeft(2, '0');
    final minute = timestamp!.minute.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute';
  }

  // Method to check if the task is missed
  void updateMissedStatus() {
    if (timestamp != null && DateTime.now().isAfter(timestamp!)) {
      isMissed = true;
      isCompleted = true; // Automatically mark as completed
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'priority': priority,
      'timestamp': timestamp?.toIso8601String(),
      'isCompleted': isCompleted,
      'isMissed': isMissed,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      note: json['note'],
      priority: json['priority'],
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      isCompleted: json['isCompleted'],
      isMissed: json['isMissed'] ?? false,
    );
  }
}
