import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> fetchedData = [
    {
      'title': 'Item 1',
      'subtitle': 'Subtitle 1',
      'icon': Icons.favorite,
    },
    {
      'title': 'Item 2',
      'subtitle': 'Subtitle 2',
      'icon': Icons.star,
    },
    {
      'title': 'Item 3',
      'subtitle': 'Subtitle 3',
      'icon': Icons.bookmark,
    },
  ];
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
                  Icon(
                    Icons.menu_book_outlined,
                    size: 50,
                  ),
                  Text("Homepage",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Icon(
                    Icons.notifications,
                    size: 50,
                  ),
                ],
              ),
              Text("List of tasks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                
            ],
          ),
        ));
  }
}
