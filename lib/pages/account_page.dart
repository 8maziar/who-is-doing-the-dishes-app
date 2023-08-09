        import 'package:flutter/material.dart';
        import 'package:firebase_auth/firebase_auth.dart';
        import '../components/task_tile.dart';
        import "package:google_fonts/google_fonts.dart";
        import 'package:lottie/lottie.dart';
        import 'select_avatar.dart';
        import 'dart:io';

          class AccountPage extends StatefulWidget {
            const AccountPage({super.key});

            @override
            _AccountPageState createState() => _AccountPageState();
          }

          class _AccountPageState extends State<AccountPage> {
            bool _showChangeButton = false;
            File? _selectedImage;

            @override
            void initState() {
              super.initState();

              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  _showChangeButton = true;
                });
              });
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
                              margin: EdgeInsets.only(top: 30.0),
                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      height: 250,
                                    )
                                  : Lottie.network(
                                      'https://lottie.host/c772a776-15f3-4289-95b9-42267e43b322/Gg7NDzFyfs.json',
                                      height: 250,
                                    ),
                            ),
                            
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
                                    begin: Offset(0.5, 0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: ModalRoute.of(context)!.animation!,
                                    curve: Curves.easeOut,
                                  )),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final selectedImage = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AvatarSelectionPage(),
                                        ),
                                      );

                                      if (selectedImage != null) {
                                        setState(() {
                                          _selectedImage = selectedImage;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: Text(
                                      'Change',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                     /*  
                     FRIENDS: 
                      Positioned(
                          top: MediaQuery.of(context).size.height / 2 - 30, // Vertically centered
                          right: 16.0, // Aligned to the right side
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                          Text(
                            "Friends:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                              SizedBox(height: 5, width: 5,),
                              FloatingActionButton(
                                onPressed: () {

                                },
                                child: Lottie.network('https://lottie.host/574176dd-97a5-4a71-8801-c2805e95706d/rZxxNC6sQK.json'),
                              ),
                              SizedBox(height: 5, width: 5,),
                              FloatingActionButton(
                                onPressed: () {

                                },
                                child: Lottie.network('https://lottie.host/49128aea-acca-4a50-a6bd-a5e4e98f9925/zAdrGKPK8w.json'),
                              ),

                            ],
                          ),
                        ), */
                        SizedBox(height: 20),
                        const TaskTile(userTask: "Do The Dishes"),
                        SizedBox(height: 10),
                        const TaskTile(userTask: "Wash The Dog"),
                        SizedBox(height: 10),
                        const TaskTile(userTask: "Do The Groceries"),
                        SizedBox(height: 10),
                        const TaskTile(userTask: "Take The Kids To School"),

                      ],
                    ),
                  ),
                ),
              );
            }
          }