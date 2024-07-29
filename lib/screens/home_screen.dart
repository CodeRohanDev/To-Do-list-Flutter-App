import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Center(
        child: Text('No tasks yet!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task action
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
