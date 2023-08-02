import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trail/reponsive_handler.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
  }
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCmZ0caWHbtF7qsg4lkWFiEQk6Q81mu9Uw",
        authDomain: "budget-app-f48c7.firebaseapp.com",
        projectId: "budget-app-f48c7",
        storageBucket: "budget-app-f48c7.appspot.com",
        messagingSenderId: "711173965272",
        appId: "1:711173965272:web:2f3b8450bb6f47a8e85ead",
        measurementId: "G-8CQHHRC96D",
      ),
    );

    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Buget App",
      home: ResponsiveHandler(),
    );
  }
}
