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
                  return ListView.builder(
                    itemCount: choreData.length,
                    itemBuilder: (context, index) {
                      final key = choreData.keys.elementAt(index);
                      final value = choreData[key];
                      return ListTile(
                        title: Text('$key: $value'),
                      );
                    },
                  );
                }
              }
              // Handle the case when data is missing or null
              return Center(child: Text('No data found'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
