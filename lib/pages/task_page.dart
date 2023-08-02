import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whos_doing_the_dishes/data/get_chores_by-user.dart';

class taskPage extends StatelessWidget {
  final String data;
  const taskPage({required this.data, Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('single task'),
      ),
      body: GestureDetector(
        onTap: () {
          print(data);
        },
        child: Center(
          child:
              Text('gugjguj'), // Displaying the data that was passed as a prop
        ),
      ),
    );
  }
}
