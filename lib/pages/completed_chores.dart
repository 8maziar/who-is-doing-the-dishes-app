import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'task_page.dart';
import 'package:lottie/lottie.dart';


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
  bool showAnimation = true;

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
      body: Column(
        children: [
          if (showAnimation)
            Lottie.network(
              'https://lottie.host/d3f7f0f2-0a7e-4727-9622-992729361764/jt3Uoi5a18.json',
              height: 250,
            ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: getCompletedDocIds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  showAnimation = false; // Hide the animation once the data is loaded
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
                              return Column(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ListTile(
                                        textColor: Colors.white,
                                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                                        tileColor: Color.fromARGB(255, 2, 197, 191),
                                        title: Text(taskName),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.fromHeight(52),
                                    ),
                                    child: Text(
                                      'Share',
                                      style: TextStyle(fontSize: 28),
                                    ),
                                    onPressed: () async {
                                      await Share.share(
                                        'I\'ve done this tasks\n\n$taskName'
                                      );
                                    },
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}