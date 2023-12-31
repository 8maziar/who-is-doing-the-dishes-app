import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whos_doing_the_dishes/pages/completed_chores.dart';
import 'package:whos_doing_the_dishes/pages/create_new_chore.dart';
import 'package:whos_doing_the_dishes/pages/home_page.dart';
import 'package:whos_doing_the_dishes/pages/account_page.dart';

import 'new_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final screens = [
    const HomePage2(),
    const Calendar(),
    const NewChore(),
    const AccountPage(),
    const CompletedChores()
  ];

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 109, 197),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: screens[_currentIndex],
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
            backgroundColor: Color.fromARGB(255, 2, 109, 197),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
            backgroundColor: Color.fromARGB(255, 46, 135, 229),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 40),
            label: 'Add',
            backgroundColor: Color.fromARGB(255, 24, 179, 86),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
            backgroundColor: Color.fromARGB(255, 39, 162, 176),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Completed',
            backgroundColor: Color.fromARGB(255, 2, 197, 191),
          ),
        ],
      ),
    );
  }
}
