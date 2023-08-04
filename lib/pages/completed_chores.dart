import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_page.dart';

class CompletedChores extends StatefulWidget {
  const CompletedChores({Key? key}) : super(key: key);

  @override
  State<CompletedChores> createState() => _CompletedChoresState();
}

Future<List<String>> getCompletedDocIds() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return [];
  }

  final completedDocs = await FirebaseFirestore.instance
      .collection('chores')
      .where('assignedTo', isEqualTo: user.email)
      .where('isDone', isEqualTo: true)
      .get();

  return completedDocs.docs.map((doc) => doc.id).toList();
}

class _CompletedChoresState extends State<CompletedChores> {
  Future<String> getTaskName(String documentId) async {
    final taskSnapshot = await FirebaseFirestore.instance
        .collection('chores')
        .doc(documentId)
        .get();

    final taskData = taskSnapshot.data();
    if (taskData != null && taskData.containsKey('title')) {
      return taskData['title'];
    } else {
      return 'Unknown Task';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Chores'),
      ),
      body: FutureBuilder<List<String>>(
        future: getCompletedDocIds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final completedDocIDs = snapshot.data ?? [];
            if (completedDocIDs.isEmpty) {
              return const Center(child: Text('No completed tasks found.'));
            }
            return ListView.builder(
              itemCount: completedDocIDs.length,
              itemBuilder: (context, index) {
                final documentId = completedDocIDs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return taskPage(documentId: documentId);
                        },
                      ),
                    );
                  },
                  child: FutureBuilder<String>(
                    future: getTaskName(documentId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final taskName = snapshot.data ?? 'Unknown Task';
                        return ListTile(
                          title: Text(taskName),
                        );
                      } else {
                        return const ListTile(
                          title: Text('Loading...'),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
