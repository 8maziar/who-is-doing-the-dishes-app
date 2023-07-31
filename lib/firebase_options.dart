// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCyP16dSkCdNDE1V_oXZ_6t-aMC9MMiC60',
    appId: '1:386768511142:web:3bc303ff0d2005eefc1467',
    messagingSenderId: '386768511142',
    projectId: 'who-is-washing-the-dishes',
    authDomain: 'who-is-washing-the-dishes.firebaseapp.com',
    storageBucket: 'who-is-washing-the-dishes.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0fLN7C4eLMoqbw_gsHL8wAUbTrabGcYQ',
    appId: '1:386768511142:android:8ddce94c3061b60ffc1467',
    messagingSenderId: '386768511142',
    projectId: 'who-is-washing-the-dishes',
    storageBucket: 'who-is-washing-the-dishes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMSw5g9SazFvD1b9rNlh1hNr0kzyiut_U',
    appId: '1:386768511142:ios:bdd6dcaeed07f8a5fc1467',
    messagingSenderId: '386768511142',
    projectId: 'who-is-washing-the-dishes',
    storageBucket: 'who-is-washing-the-dishes.appspot.com',
    iosClientId: '386768511142-ivpg7jug22cvdev919ufun47kifpbqiq.apps.googleusercontent.com',
    iosBundleId: 'com.example.whosDoingTheDishes',
  );
}
