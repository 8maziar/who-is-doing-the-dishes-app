import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:whos_doing_the_dishes/pages/hub_page.dart';

class NewChore extends StatefulWidget {
  const NewChore({super.key});

  @override
  State<NewChore> createState() => _NewChoreState();
}

class _NewChoreState extends State<NewChore> {
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
                DateTimeFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month),
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    labelText: 'Deadline',
                  ),
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  dateFormat: DateFormat('y/M/d, hh:mm'),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) => (e?.day ?? 0) == 1
                      ? 'Invalid Date. Select Later Date'
                      : null,
                  onDateSelected: (DateTime value) {
                    taskDeadline = value.toString();
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

                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
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
