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
        return macos;
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
    apiKey: 'AIzaSyBSW2M9M7n_2mqNRv86ue5F1GMpOE_7WRs',
    appId: '1:98452995691:web:48c28b31308e8d8d777b2e',
    messagingSenderId: '98452995691',
    projectId: 'anpr-762d0',
    authDomain: 'anpr-762d0.firebaseapp.com',
    databaseURL: 'https://anpr-762d0-default-rtdb.firebaseio.com',
    storageBucket: 'anpr-762d0.appspot.com',
    measurementId: 'G-VS4PPWVQ1N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXhLiLvGD7etWISFWWokuoKabHU18ZWzw',
    appId: '1:98452995691:android:c9022e3b2a755e58777b2e',
    messagingSenderId: '98452995691',
    projectId: 'anpr-762d0',
    databaseURL: 'https://anpr-762d0-default-rtdb.firebaseio.com',
    storageBucket: 'anpr-762d0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6kqrjKiMmUpBio1MNaDg5dmrKPmcCS3c',
    appId: '1:98452995691:ios:6f2f1b7ac26964ed777b2e',
    messagingSenderId: '98452995691',
    projectId: 'anpr-762d0',
    databaseURL: 'https://anpr-762d0-default-rtdb.firebaseio.com',
    storageBucket: 'anpr-762d0.appspot.com',
    iosClientId: '98452995691-vbv6h5jlpi5jgijjmdohsa3asoje8kq3.apps.googleusercontent.com',
    iosBundleId: 'com.example.anpr',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC6kqrjKiMmUpBio1MNaDg5dmrKPmcCS3c',
    appId: '1:98452995691:ios:ed4435a1b62bd244777b2e',
    messagingSenderId: '98452995691',
    projectId: 'anpr-762d0',
    databaseURL: 'https://anpr-762d0-default-rtdb.firebaseio.com',
    storageBucket: 'anpr-762d0.appspot.com',
    iosClientId: '98452995691-fh7u9pj2u2jt3o7j195tsqj14rnkr0p1.apps.googleusercontent.com',
    iosBundleId: 'com.example.anpr.RunnerTests',
  );
}