import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whos_doing_the_dishes/pages/home_page.dart';
<<<<<<< HEAD
import 'completedChores.dart';
=======
import 'package:whos_doing_the_dishes/pages/messages.dart';

>>>>>>> 30fdef295c6f8917e9af50d6d817d8b6a4115fe8
import 'createNewChore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

<<<<<<< HEAD
  final screens = [HomePage2(), Placeholder(), NewChore(), Placeholder(), CompletedChores() ];
=======
  final screens = [HomePage2(), Placeholder(), NewChore(), Messenger(), Placeholder() ];
>>>>>>> 30fdef295c6f8917e9af50d6d817d8b6a4115fe8

  //get docs

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
              backgroundColor: Color.fromARGB(255, 237, 206, 31)),
         
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 40),
              label: 'Add',
              backgroundColor: Colors.blue),
          
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
              backgroundColor: Colors.purple),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Completed',
              backgroundColor: Colors.orange),
        ],
      ),
    );
  }
}
