import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String userTask;
  const TaskTile({
    super.key,
    required this.userTask,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 251, 252, 252),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFB6C6D4),
            spreadRadius: -8,
            blurRadius: 10.0,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.5),
            blurRadius: 10,
            offset: Offset(-3, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.check_box_outline_blank),
          Text(userTask),
          const Icon(Icons.delete, color: Colors.red)
        ],
      ),
    );
  }
}
