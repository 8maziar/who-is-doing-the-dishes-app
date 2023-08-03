import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewChore extends StatefulWidget {
  const NewChore({super.key});

  @override
  State<NewChore> createState() => _NewChoreState();
}

class _NewChoreState extends State<NewChore> {
  final _date = TextEditingController();

  String? taskTitle;
  String? taskDescription;
  String? taskPriority;
  String? taskDeadline;

  @override
  Widget build(BuildContext context) {
    CollectionReference chores =
        FirebaseFirestore.instance.collection('chores');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.task),
                      hintText: "What is your task",
                      label: Text("task")),
                  onChanged: (value) {
                    taskTitle = value;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.book),
                      hintText: "Describe Your Task",
                      label: Text("Description")),
                  onChanged: (value) {
                    taskDescription = value;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.flag),
                      hintText: "High, Medium or Low",
                      label: Text("Priority")),
                  onChanged: (value) {
                    taskPriority = value;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _date,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month),
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    labelText: 'Deadline',
                  ),
                  onTap: () async {
                    DateTime? pickdate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));

                    if (pickdate != null) {
                      setState(() {
                        _date.text = DateFormat('yyyy-MM-dd').format(pickdate);
                        taskDeadline = _date.text;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () {
                      chores
                          .add({
                            'title': taskTitle,
                            'description': taskDescription,
                            "priority": taskPriority,
                            "deadline": taskDeadline,
                            "isDone": false,
                            "timeOfCompletion": null
                          })
                          .then(
                            (value) => print('Task added'),
                          )
                          .catchError((error) => print(error));
                    },
                    child: const Text("Create Task")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
