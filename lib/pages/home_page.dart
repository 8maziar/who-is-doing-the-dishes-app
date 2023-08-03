import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whos_doing_the_dishes/pages/task_page.dart';
import '../data/get_chores_by-user.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

final user = FirebaseAuth.instance.currentUser!;
Future<List<String>> getAssignedDocIds() async {
  final assignedDocs = await FirebaseFirestore.instance
      .collection('chores')
      .where('assignedTo', isEqualTo: user.email)
      .get();

  return assignedDocs.docs.map((doc) => doc.id).toList();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 40,
              ),
              Text("Homepage",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              Icon(
                Icons.notifications,
                size: 40,
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("List of tasks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                              return taskPage(documentId: documentId);
                            },
                          ));
                        },
                        child: Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFB6C6D4),
                                spreadRadius: -8,
                                blurRadius: 10.0,
                                offset: Offset(4, 4),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
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
                                    },
                                  ),
                                  GetChores(documentId: documentId),
                                ],
                              ),
                              IconButton(
                                color: Colors.red,
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await deleteTask(documentId);
                                  setState(() {
                                    isCheckedMap.remove(documentId);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
