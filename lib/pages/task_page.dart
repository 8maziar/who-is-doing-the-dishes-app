import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class taskPage extends StatelessWidget {
  final String documentId;
  const taskPage({required this.documentId, Key? key}) : super(key: key);

  Future<DocumentSnapshot<Map<String, dynamic>>> getChoreData() async {
    return FirebaseFirestore.instance
        .collection('chores')
        .doc(documentId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Color.fromARGB(255, 237, 206, 31),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getChoreData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final choreData = snapshot.data!.data();
                if (choreData != null) {
                  // Display the chore data here
                  return SingleChildScrollView(
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: choreData.entries.map((entry) {
                            final key = entry.key;
                            final value = entry.value;
                            return ListTile(
                              title: Text(
                                '$key:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '$value',
                                style: TextStyle(fontSize: 16),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  print('edit');
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }
              }
              return Center(child: Text('No data found'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('uvhrf');
        },
        backgroundColor: Color.fromARGB(255, 237, 206, 31),
        child: Icon(Icons.check),
      ),
    );
  }
}
