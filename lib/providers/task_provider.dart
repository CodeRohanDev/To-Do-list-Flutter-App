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
      _tasks = decodedTasks.map((taskJson) {
        final task = Task.fromJson(taskJson);
        task.updateMissedStatus(); // Check if the task is missed
        return task;
      }).toList();
      _sortTasks();
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
        title: title, note: note, priority: priority, timestamp: timestamp);
    task.updateMissedStatus(); // Check if the newly added task is missed
    _tasks.add(task);
    _sortTasks();
    _saveTasks();
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    updatedTask.updateMissedStatus(); // Check if the updated task is missed
    _tasks[index] = updatedTask;
    _sortTasks();
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    final task = _tasks[index];
    if (task.isMissed) {
      task.isMissed = false; // Allow user to uncheck a missed task
    } else {
      task.isCompleted = !task.isCompleted;
    }
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
}
