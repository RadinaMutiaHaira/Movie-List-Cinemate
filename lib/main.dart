import 'package:flutflix/colors.dart';
import 'package:flutflix/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutflix/screen/login.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCLPufh6ip-CIFKjLMEx24LXRAT-sN021g',
      appId: '1:738564776121:android:837290e8bbf3661e077b68',
      messagingSenderId: '738564776121',
      projectId: 'cinemate-d947e',
      // authDomain: 'your_auth_domain',
      // measurementId: 'your_measurement_id',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Cinemate',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colours.scaffoldBgColor,
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}