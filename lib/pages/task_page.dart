import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class TaskPage extends StatelessWidget {
  final String documentId;
  const TaskPage({required this.documentId, Key? key}) : super(key: key);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getChoreData() {
    return FirebaseFirestore.instance
        .collection('chores')
        .doc(documentId)
        .snapshots();
  }

  Future<void> updateChoreData(Map<String, dynamic> newData) {
    return FirebaseFirestore.instance
        .collection('chores')
        .doc(documentId)
        .update(newData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: const Color.fromARGB(255, 237, 206, 31),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getChoreData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final choreData = snapshot.data!.data();
                if (choreData != null) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        /* Lottie.network('https://lottie.host/a2105267-7e4c-4929-80e9-70c93f46174f/sauecQ8A7W.json', height: 200), */
                        Lottie.network('https://lottie.host/1839d2f6-41e1-4b4e-9adc-ae475a725e23/pOzvog6OuM.json', height: 250),
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: choreData.entries.map((entry) {
                                final key = entry.key;
                                final value = entry.value;
                                return ListTile(
                                  title: Text(
                                    '$key:',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '$value',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showUpdateDialog(context, key, value);
                                      print('edit');
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return const Center(child: Text('No data found'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        backgroundColor: const Color.fromARGB(255, 237, 206, 31),
        child: const Icon(Icons.check),
      ),
    );
  }

  void _showUpdateDialog(
      BuildContext context, String key, dynamic currentValue) {
    TextEditingController _controller =
        TextEditingController(text: '$currentValue');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update $key'),
          content: TextFormField(
            controller: _controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call the function to update data in Firestore
                await updateChoreData({key: _controller.text});
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}