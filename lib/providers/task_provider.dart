import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksJson);
      _tasks = decodedTasks.map((taskJson) => Task.fromJson(taskJson)).toList();
      _sortTasks();
      _checkMissedTasks(); // Check for missed tasks on load
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(_tasks.map((task) => task.toJson()).toList());
    prefs.setString('tasks', tasksJson);
  }

  void addTask(String title, String note, int priority, DateTime? timestamp) {
    final task = Task(
      title: title,
      note: note,
      priority: priority,
      timestamp: timestamp,
    );
    _tasks.add(task);
    _sortTasks();
    _checkMissedTasks(); // Check for missed tasks whenever a new task is added
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    if (_tasks[index].isMissed) {
      // Do not allow toggling if the task is missed
      return;
    }

    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }

  void _sortTasks() {
    _tasks.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void _checkMissedTasks() {
    final now = DateTime.now();
    for (var task in _tasks) {
      if (task.timestamp != null &&
          !task.isCompleted &&
          !task.isMissed &&
          task.timestamp!.isBefore(now)) {
        task.isMissed = true;
        task.isCompleted = true;
      }
    }
    _saveTasks();
    notifyListeners();
  }
}
