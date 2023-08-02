import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetChores extends StatelessWidget {
  final String documentId;

  GetChores({required this.documentId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Get the collection reference
    CollectionReference chores =
        FirebaseFirestore.instance.collection('chores');

    return FutureBuilder<DocumentSnapshot>(
      future: chores.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          // Check if the 'assignedTo' field matches the current user's UID
          if (data!['assignedTo'] == user!.email) {
            print(user);
            return Text('Task: ${data['title']}');
            // If not assigned to the current user, return an empty container
          }
        }
        return Text('Loading...');
      }),
    );
  }
}
