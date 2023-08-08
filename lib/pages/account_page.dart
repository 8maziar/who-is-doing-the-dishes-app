import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/task_tile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 232, 245),
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                height: 300,
                width: 300,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('lib/images/profile.jpg'),
                        fit: BoxFit.cover),
                    border: Border.all(color: Colors.blue, width: 10),
                    borderRadius: BorderRadius.circular(200)),
              ),
              const SizedBox(height: 30),
              Text(
                user?.email ?? 'N/A',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 10),
              const TaskTile(userTask: "Do The Dishes"),
              const SizedBox(height: 10),
              const TaskTile(userTask: "Wash The Dog"),
              const SizedBox(height: 10),
              const TaskTile(userTask: "Do The Groceries"),
            ],
          ),
        ),
      ),
    );
  }
}
