// widgets/task_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/task_provider.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.note.isNotEmpty) Text(task.note),
              if (task.timestamp != null)
                Text('Due: ${task.timestamp!.toLocal()}'
                    .split(' ')[0]), // Display timestamp
            ],
          ),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (_) {
              Provider.of<TaskProvider>(context, listen: false)
                  .toggleTaskCompletion(index);
            },
          ),
          onLongPress: () {
            Provider.of<TaskProvider>(context, listen: false).deleteTask(index);
          },
        );
      },
    );
  }
}
