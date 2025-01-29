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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDTVT1JAVYdbfXY3qFM_adpJM_oKaZ2hyQ',
    appId: '1:425904182108:web:c44714e2706187e9406799',
    messagingSenderId: '425904182108',
    projectId: 'bano-qabil-lms',
    authDomain: 'bano-qabil-lms.firebaseapp.com',
    storageBucket: 'bano-qabil-lms.firebasestorage.app',
    measurementId: 'G-XLJY344SKQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYyWsL8h0rP-LKSqJgJChGExqmH4MxT_E',
    appId: '1:425904182108:android:fc02c8271ebc4f3d406799',
    messagingSenderId: '425904182108',
    projectId: 'bano-qabil-lms',
    storageBucket: 'bano-qabil-lms.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAunfnFXc0DeqilQh6bDqkZLFUCZPlTW8g',
    appId: '1:425904182108:ios:56170ccb38aee7f2406799',
    messagingSenderId: '425904182108',
    projectId: 'bano-qabil-lms',
    storageBucket: 'bano-qabil-lms.firebasestorage.app',
    iosBundleId: 'com.example.qabilacademy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAunfnFXc0DeqilQh6bDqkZLFUCZPlTW8g',
    appId: '1:425904182108:ios:56170ccb38aee7f2406799',
    messagingSenderId: '425904182108',
    projectId: 'bano-qabil-lms',
    storageBucket: 'bano-qabil-lms.firebasestorage.app',
    iosBundleId: 'com.example.qabilacademy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDTVT1JAVYdbfXY3qFM_adpJM_oKaZ2hyQ',
    appId: '1:425904182108:web:4fb2487193e42281406799',
    messagingSenderId: '425904182108',
    projectId: 'bano-qabil-lms',
    authDomain: 'bano-qabil-lms.firebaseapp.com',
    storageBucket: 'bano-qabil-lms.firebasestorage.app',
    measurementId: 'G-KFHDZK2PGX',
  );
}
