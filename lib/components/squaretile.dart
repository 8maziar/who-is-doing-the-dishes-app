import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 231, 229, 229)),
        borderRadius: BorderRadius.circular(16),
        color: Color.fromARGB(255, 201, 197, 197),
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
