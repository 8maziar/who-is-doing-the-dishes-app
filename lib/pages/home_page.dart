import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu_book_outlined,
                  size: 50,),
                  Text("Homepage",
                  style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold)),
                Icon(Icons.menu_book_outlined,
                  size: 50,),
                ],
              ),
            ],
        ),
      )
    );
      
  }
}