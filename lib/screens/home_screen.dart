// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/task_provider.dart';
import 'package:todo_list/widgets/task_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedPriority = 1;
  DateTime? _selectedTimestamp;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _taskController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: TaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskBottomSheet(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      transitionAnimationController: _animationController,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Card(
                elevation: 8.0,
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Task',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _taskController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Task Title',
                            prefixIcon: Icon(Icons.title),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Task Note',
                            prefixIcon: Icon(Icons.note),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.priority_high, color: Colors.red),
                            SizedBox(width: 10),
                            Text('Priority:'),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: PopupMenuButton<int>(
                                  onSelected: (int value) {
                                    setState(() {
                                      _selectedPriority = value;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<int>>[
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(Icons.priority_high,
                                              color: Colors.red),
                                          SizedBox(width: 10),
                                          Text('High Priority'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          Icon(Icons.priority_high,
                                              color: Colors.orange),
                                          SizedBox(width: 10),
                                          Text('Medium Priority'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 3,
                                      child: Row(
                                        children: [
                                          Icon(Icons.priority_high,
                                              color: Colors.green),
                                          SizedBox(width: 10),
                                          Text('Low Priority'),
                                        ],
                                      ),
                                    ),
                                  ],
                                  child: ListTile(
                                    title: Text(
                                        '${_priorityToString(_selectedPriority)}'),
                                    trailing: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text('Due Date and Time:'),
                            subtitle: Text(
                              _selectedTimestamp == null
                                  ? 'Select Date and Time'
                                  : DateFormat('yyyy-MM-dd – kk:mm')
                                      .format(_selectedTimestamp!),
                            ),
                            trailing: Icon(Icons.calendar_today),
                            onTap: () => _selectDateTime(context, setState),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedTimestamp != null &&
                                  _selectedTimestamp!
                                      .isBefore(DateTime.now())) {
                                Fluttertoast.showToast(
                                  msg: 'Please select a future date and time',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }
                              final taskProvider = Provider.of<TaskProvider>(
                                  context,
                                  listen: false);
                              taskProvider.addTask(
                                _taskController.text,
                                _noteController.text,
                                _selectedPriority,
                                _selectedTimestamp,
                              );
                              Navigator.pop(context);
                              _taskController.clear();
                              _noteController.clear();
                              _selectedTimestamp = null;
                              setState(() {
                                _selectedPriority = 1; // Default priority
                              });
                            }
                          },
                          child: Text('Add Task'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _priorityToString(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }

  Future<void> _selectDateTime(
      BuildContext context, StateSetter setState) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (selectedTime != null) {
        setState(() {
          _selectedTimestamp = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }
}
