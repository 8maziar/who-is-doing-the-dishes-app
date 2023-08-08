import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whos_doing_the_dishes/pages/authpage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());

  /*await FirebaseMessaging.instance.getInitialMessage();
  await pushNotifications().initNotifications();
  runApp(const MyApp());*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      

        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 219, 228, 236),

        ));

  }
}
