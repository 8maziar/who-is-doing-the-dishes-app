
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';


class AvatarSelectionPage extends StatefulWidget {
  @override
  _AvatarSelectionPageState createState() => _AvatarSelectionPageState();
}

      class _AvatarSelectionPageState extends State<AvatarSelectionPage> {

        List<String> animationUrls = [
          'https://lottie.host/574176dd-97a5-4a71-8801-c2805e95706d/rZxxNC6sQK.json',
          'https://lottie.host/49128aea-acca-4a50-a6bd-a5e4e98f9925/zAdrGKPK8w.json',
          'https://lottie.host/33dd57c7-f862-4a0b-9ba8-4b8453360585/hsg0IqS0Re.json',
          'https://lottie.host/c772a776-15f3-4289-95b9-42267e43b322/Gg7NDzFyfs.json',
          'https://lottie.host/d77e8750-34e6-49da-86fc-61fd4d7211aa/M7scQgPeGH.json',
          'https://lottie.host/ea70bc86-2345-4d5d-a2c8-e35345261fc3/wrlbsF4spH.json',
          'https://lottie.host/99e81ced-6efa-4351-b1fe-e4f522e9d671/dCWTOlkSkc.json',
          'https://lottie.host/9b12c71e-e82e-44c0-b6e5-dc319888a0da/Y8jf8CV8om.json',
          'https://lottie.host/1c1b465f-d857-4512-92b9-c571246386dc/nV0gWfOv3u.json',

        ];

        String? _selectedAnimationUrl; 

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
                                height: 150,
                                width: 150,
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