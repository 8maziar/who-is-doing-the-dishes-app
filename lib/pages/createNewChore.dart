// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whos_doing_the_dishes/components/mytextfield.dart';
import '../main.dart';

class NewChore extends StatefulWidget {
  const NewChore({super.key});

  @override
  State<NewChore> createState() => _NewChoreState();
}

class _NewChoreState extends State<NewChore> {
  // final taskTitle = TextEditingController();
  // final taskDescription = TextEditingController();
  // final taskPriority = TextEditingController();

  String? taskTitle;
  String? taskDescription;
  String? taskPriority;

  @override
  Widget build(BuildContext context) {
    CollectionReference chores =
        FirebaseFirestore.instance.collection('chores');
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('New Task'),
          ),
          body: Form(
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
                    taskTitle = value;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.flag),
                      hintText: "High, Medium or Low",
                      label: Text("Priority")),
                  onChanged: (value) {
                    taskTitle = value;
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () {
                      chores
                          .add({
                            'title': taskTitle,
                            'description': taskDescription,
                            "priority": taskPriority
                          })
                          .then(
                            (value) => print('Task added'),
                          )
                          .catchError((error) => print(error));
                    },
                    child: Text("Create Task")),
              ],
            ),
          )),
    );
  }
}
