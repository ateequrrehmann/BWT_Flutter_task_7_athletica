// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCsdkWXzkydrxh8CYV7L9ut6Dei_wwFvII',
    appId: '1:251148936784:web:94eb345d8ab0ba5abf1355',
    messagingSenderId: '251148936784',
    projectId: 'athletica-39b15',
    authDomain: 'athletica-39b15.firebaseapp.com',
    storageBucket: 'athletica-39b15.appspot.com',
    measurementId: 'G-MG73C63G2R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBn6fOPtJJA3j5eXfgcm_X32qIp2RBaiIo',
    appId: '1:251148936784:android:c9c49b3c088f8d73bf1355',
    messagingSenderId: '251148936784',
    projectId: 'athletica-39b15',
    storageBucket: 'athletica-39b15.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC01ZgBl6DfPeIagCU8OODYzniVpzsaR1Y',
    appId: '1:251148936784:ios:5aea26ee3260f5ffbf1355',
    messagingSenderId: '251148936784',
    projectId: 'athletica-39b15',
    storageBucket: 'athletica-39b15.appspot.com',
    iosBundleId: 'com.example.athleticaAdmin',
  );
}
