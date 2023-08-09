import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatelessWidget {
  final String documentId;
  const TaskPage({required this.documentId, Key? key}) : super(key: key);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getChoreData() {
    return FirebaseFirestore.instance
        .collection('chores')
        .doc(documentId)
        .snapshots();
  }

  Future<void> updateChoreData(Map<String, dynamic> newData) {
    return FirebaseFirestore.instance
        .collection('chores')
        .doc(documentId)
        .update(newData);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Chore Details'),
      backgroundColor: const Color.fromARGB(255, 5, 132, 243),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: getChoreData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final choreData = snapshot.data!.data();
              if (choreData != null) {
                final imageUrl = choreData['image'] as String?;
                final Timestamp deadlineTimestamp = choreData['deadline'] as Timestamp;
                final DateTime deadlineDateTime = DateTime.fromMillisecondsSinceEpoch(deadlineTimestamp.seconds * 1000 + deadlineTimestamp.nanoseconds ~/ 1000000);
                final formattedDeadline = DateFormat('y/M/d hh:mm').format(deadlineDateTime.toLocal());

                final List<String> fieldDisplayOrder = ['title', 'priority', 'description', 'weekday', 'deadline', 'assignedTo'];
                final orderedFilteredChoreData = fieldDisplayOrder.map((field) {
                  final entry = choreData.entries.firstWhere((entry) => entry.key == field, orElse: () => MapEntry(field, null));
                  return entry;
                }).toList();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              
                              imageUrl ?? 'https://images.unsplash.com/photo-1496262967815-132206202600?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1223&q=80',
                              width: 500,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      ...orderedFilteredChoreData.map((entry) {
                        if (entry.value != null) {
                          final key = entry.key;
                          final value = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                '$key:',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: key == 'deadline' ? Text(formattedDeadline) : Text(
                                '$value',
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateDialog(context, key, value);
                                  print('edit');
                                },
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 250,
                        child: Center(
                          child: Lottie.network(
                            'https://lottie.host/1839d2f6-41e1-4b4e-9adc-ae475a725e23/pOzvog6OuM.json',
                            height: 200,
                            frameRate: FrameRate.max,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                    return const Center(child: Text('No data found'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: Color.fromARGB(255, 5, 132, 243),
                child: const Icon(Icons.check),
              ),
            );
          }



          void _showUpdateDialog(
              BuildContext context, String key, dynamic currentValue) {
            TextEditingController _controller =
                TextEditingController(text: '$currentValue');

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Update $key'),
                  content: TextFormField(
                    controller: _controller,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await updateChoreData({key: _controller.text});
                        Navigator.of(context).pop();
                      },
                      child: const Text('Update'),
                    ),
                  ],
                );
              },
            );
          }
        }
