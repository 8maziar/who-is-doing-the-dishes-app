import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whos_doing_the_dishes/pages/task_page.dart';

import '../data/get_chores_by-user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final user = FirebaseAuth.instance.currentUser!;

  //get docs
  Future<List<String>> getAssignedDocIds() async {
    final assignedDocs = await FirebaseFirestore.instance
        .collection('chores')
        .where('assignedTo', isEqualTo: user.email)
        // Filter based on assignedTo field
        .get();

    return assignedDocs.docs.map((doc) => doc.id).toList();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 206, 31),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
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
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      ///////////////////////////////
                      itemCount: assignedDocIDs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return taskPage(data: assignedDocIDs[index]);
                              },
                            ));
                          },
                          child: Container(
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
                                )
                              ],
                            ),
                            child: ListTile(
                              title:
                                  GetChores(documentId: assignedDocIDs[index]),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color.fromARGB(255, 237, 206, 31)),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
