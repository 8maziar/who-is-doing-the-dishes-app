import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/task_tile.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:lottie/lottie.dart';
import 'select_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _showChangeButton = false;
  String? _avatarUrl;
  @override
  void initState() {
    super.initState();
    getUserAvatarUrl().then((avatarUrl) {
      setState(() {
        _avatarUrl = avatarUrl;
      });
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showChangeButton = true;
      });
    });
  }

  Future<String?> getUserAvatarUrl() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        return userDoc.get('avatar') ?? null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 30.0),
                      child: _avatarUrl != null
                          ? Lottie.network(
                              _avatarUrl!,
                              height: 250,
                            )
                          : Lottie.network(
                              'https://lottie.host/c772a776-15f3-4289-95b9-42267e43b322/Gg7NDzFyfs.json',
                              height: 250,
                            )),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      user?.email ?? 'N/A',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  if (_showChangeButton)
                    Positioned(
                      top: 240.0,
                      right: 95.0,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.5, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: ModalRoute.of(context)!.animation!,
                          curve: Curves.easeOut,
                        )),
                        child: ElevatedButton(
                          onPressed: () async {
                            final selectedAvatarUrl =
                                await Navigator.push<String?>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AvatarSelectionPage(),
                              ),
                            );
                            if (selectedAvatarUrl != null) {
                              setState(() {
                                _avatarUrl = selectedAvatarUrl;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
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
    );
  }
}
