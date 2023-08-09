import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';


class AvatarSelectionPage extends StatefulWidget {
  @override
  _AvatarSelectionPageState createState() => _AvatarSelectionPageState();
}

      class _AvatarSelectionPageState extends State<AvatarSelectionPage> {

        List<String> animationUrls = [


        ];

        String? _selectedAnimationUrl; 


                @override
                void initState() {
                  super.initState();
                  fetchAvatarUrls();
                }

                Future<void> fetchAvatarUrls() async {
                  QuerySnapshot<Map<String, dynamic>> snapshot =
                      await FirebaseFirestore.instance.collection('avatars').get();

                  setState(() {
                    animationUrls = snapshot.docs
                        .map((doc) => doc.get('url'))
                        .cast<String>()
                        .toList();
                  });
                }




        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Select Avatar'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < animationUrls.length; i += 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var j = i; j < i + 3 && j < animationUrls.length; j++)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedAnimationUrl = animationUrls[j];
                              });
                            },
                      child: Container(
                         decoration: BoxDecoration(
                            border: Border.all(
                               color: _selectedAnimationUrl == animationUrls[j]
                                      ? Colors.blue 
                                      : Colors.transparent,
                                  width: 3, 
                                ),
                                borderRadius: BorderRadius.circular(10), 
                              ),
                              child: Lottie.network(
                                animationUrls[j],
                                height: 125,
                                width: 125,
                              ),
                            ),
                          ),
                      ],
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Save and Close'),
                  ),
                ],
              ),
            ),
          );
        }
      }
