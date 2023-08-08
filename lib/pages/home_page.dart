import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whos_doing_the_dishes/pages/task_page.dart';
import '../data/get_chores_by_user.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

final User = FirebaseAuth.instance.currentUser!;
Future<List<String>> getAssignedDocIds() async {
  final assignedDocs = await FirebaseFirestore.instance
      .collection('chores')
      .where('assignedTo', isEqualTo: User.email)
      .get();

  return assignedDocs.docs.map((doc) => doc.id).toList();
}

final userEmail = FirebaseAuth.instance.currentUser?.email;

Future<List<String>> getCompletedDocIds() async {
  final completedDocs = await FirebaseFirestore.instance
      .collection('chores')
      .where('assignedTo', isEqualTo: User.email)
      .where('isDone', isEqualTo: true)
      .get();

  return completedDocs.docs.map((doc) => doc.id).toList();
}

class _HomePage2State extends State<HomePage2> {
  Map<String, bool> isCheckedMap = {};

  Future<void> deleteTask(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chores')
          .doc(documentId)
          .delete();
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  Future<void> updateIsDone(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chores')
          .doc(documentId)
          .update({'isDone': true});
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  Future<void> updateIsNotDone(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chores')
          .doc(documentId)
          .update({'isDone': false});
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 219, 228, 236),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Homepage",
                  style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "List of tasks",
                  style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: getAssignedDocIds(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final assignedDocIDs = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: assignedDocIDs.length,
                      itemBuilder: (context, index) {
                        final documentId = assignedDocIDs[index];
                        final isChecked = isCheckedMap[documentId] ?? false;

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return TaskPage(
                                  documentId: documentId,
                                );
                              },
                            ));
                          },
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 251, 252, 252),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(182, 198, 212, 1),
                                  spreadRadius: -8,
                                  blurRadius: 10.0,
                                  offset: Offset(4, 4),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(255, 255, 255, 0.49),
                                  blurRadius: 10,
                                  offset: Offset(-3, -4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          isCheckedMap[documentId] =
                                              newValue ?? false;
                                        });
                                        if (isChecked == true) {
                                          updateIsNotDone(documentId);
                                        } else {
                                          updateIsDone(documentId);
                                        }
                                      },
                                    ),
                                    GetChores(documentId: documentId),
                                  ],
                                ),
                                IconButton(
                                  color: const Color.fromRGBO(244, 67, 54, 1),
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final result = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title:
                                                  const Text("Are you sure?"),
                                              content: const Text(
                                                  "This will permanently delete this task"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: const Text("cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: const Text("delete"),
                                                ),
                                              ],
                                            ));
                                    if (result == true) {
                                      deleteTask(documentId);
                                      setState(() {
                                        isCheckedMap.remove(documentId);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
