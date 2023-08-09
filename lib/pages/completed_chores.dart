import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'task_page.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text(
          'Completed Chores',
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                  showAnimation = false;
                  final completedDocIDs = snapshot.data ?? [];
                  if (completedDocIDs.isEmpty) {
                    return Center(
                      child: Text(
                        'No completed tasks found.',
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
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
                                return TaskPage(documentId: documentId);
                              },
                            ),
                          );
                        },
                        child: FutureBuilder<String>(
                          future: getTaskName(documentId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              final taskName = snapshot.data ?? 'Unknown Task';
                              return Card(
                                color: const Color.fromARGB(255, 2, 197, 191),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      const Icon(Icons.expand_more,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        taskName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () async {
                                      final taskName =
                                          await getTaskName(documentId);
                                      await Share.share(
                                          'I\'ve done this tasks\n\n$taskName');
                                    },
                                  ),
                                  children: [
                                    FutureBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      future: FirebaseFirestore.instance
                                          .collection('chores')
                                          .doc(documentId)
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData) {
                                          final choreData =
                                              snapshot.data!.data();
                                          if (choreData != null) {
                                            final imageUrl = choreData['image'];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                child: Image.network(
                                                  imageUrl,
                                                  height: 150,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
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
