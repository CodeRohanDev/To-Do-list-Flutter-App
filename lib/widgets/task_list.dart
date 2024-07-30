// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/task_provider.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAscending = true;
  int _selectedPriorityFilter = 0; // 0: All, 1: High, 2: Medium, 3: Low

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _sortTasks() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  void _openFilterDialog() async {
    final selectedPriority = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter by Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All'),
                leading: Radio<int>(
                  value: 0,
                  groupValue: _selectedPriorityFilter,
                  onChanged: (value) {
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
              ListTile(
                title: Text('High'),
                leading: Radio<int>(
                  value: 1,
                  groupValue: _selectedPriorityFilter,
                  onChanged: (value) {
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
              ListTile(
                title: Text('Medium'),
                leading: Radio<int>(
                  value: 2,
                  groupValue: _selectedPriorityFilter,
                  onChanged: (value) {
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
              ListTile(
                title: Text('Low'),
                leading: Radio<int>(
                  value: 3,
                  groupValue: _selectedPriorityFilter,
                  onChanged: (value) {
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedPriorityFilter);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (selectedPriority != null) {
      setState(() {
        _selectedPriorityFilter = selectedPriority;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final filteredTasks = taskProvider.tasks.where((task) {
          final matchesSearch = task.title.toLowerCase().contains(_searchQuery);
          final matchesPriority = _selectedPriorityFilter == 0 ||
              task.priority == _selectedPriorityFilter;

          return matchesSearch && matchesPriority;
        }).toList();

        // Sort tasks based on the selected order
        if (_isAscending) {
          filteredTasks.sort((a, b) => a.title.compareTo(b.title));
        } else {
          filteredTasks.sort((a, b) => b.title.compareTo(a.title));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Task Manager'),
            centerTitle: true,
            backgroundColor: Colors.teal,
            elevation: 8,
            actions: [
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: _sortTasks,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search tasks...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.teal),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.teal),
                                    onPressed: () {
                                      _searchController.clear();
                                      FocusScope.of(context).unfocus();
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: _openFilterDialog,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Container(
                          width: 6.0,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getPriorityColor(task.priority),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (task.note.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  task.note,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            if (task.timestamp != null)
                              Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 16, color: Colors.blueGrey[600]),
                                  SizedBox(width: 4),
                                  Text(
                                    'Due: ${task.getFormattedTimestamp()}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueGrey[600],
                                    ),
                                  ),
                                ],
                              ),
                            if (task.isMissed)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Missed',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            if (task.isCompleted) {
                              if (task.isMissed) {
                                // Allow user to uncheck missed tasks without confirmation
                                taskProvider.toggleTaskCompletion(index);
                              } else {
                                _showUncheckConfirmationDialog(
                                    context, index, taskProvider);
                              }
                            } else {
                              taskProvider.toggleTaskCompletion(index);
                            }
                          },
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: task.isCompleted
                                  ? Colors.teal
                                  : const Color.fromARGB(255, 238, 224, 224),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.teal,
                                width: 2.0,
                              ),
                            ),
                            child: task.isCompleted
                                ? Icon(
                                    Icons.check,
                                    size: 18.0,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        onLongPress: () {
                          _showDeleteConfirmationDialog(
                              context, index, taskProvider);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, int index, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                taskProvider.deleteTask(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showUncheckConfirmationDialog(
      BuildContext context, int index, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Uncheck'),
          content: Text('Are you sure you want to uncheck this task?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Uncheck'),
              onPressed: () {
                taskProvider.toggleTaskCompletion(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return Colors.greenAccent;
      default:
        return Colors.black;
    }
  }
}
