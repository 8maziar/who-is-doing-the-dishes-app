import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/task_tile.dart';
import "package:google_fonts/google_fonts.dart";

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 228, 236),
      appBar: AppBar(
        title: Text(
          'Account',
          style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                const SizedBox(height: 10),
                const TaskTile(userTask: "Take The Kids To School"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
