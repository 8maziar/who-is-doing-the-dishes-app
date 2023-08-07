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
  final _formKey = GlobalKey<FormState>();

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
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
                          errorStyle: TextStyle(color: Colors.red),
                          labelText: 'Deadline',
                        ),
                        mode: DateTimeFieldPickerMode.dateAndTime,
                        dateFormat: DateFormat('y/M/d, hh:mm'),
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a date';
                          }
                          DateTime currentDate = DateTime.now();
                          currentDate = DateTime(currentDate.year,
                              currentDate.month, currentDate.day);

                          if (value.isBefore(currentDate)) {
                            return 'Invalid Date. Select Later Date';
                          }
                          return null;
                        },
                        onDateSelected: (DateTime value) {
                          taskDeadline = value.toString();
                        },
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1),
                        initialDate: DateTime.now(),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.validate();
                            if (_formKey.currentState!.validate()) {
                              print('Form is valid');
                            } else {
                              print('Form is not valid');
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                action: SnackBarAction(
                                  label: 'Added',
                                  onPressed: () {},
                                ),
                                content: const Text('Task Created!'),
                                duration: const Duration(milliseconds: 5000),
                                width: 300.0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            );
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

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const HomePage()));
                          },
                          child: const Text("Create Task")),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
