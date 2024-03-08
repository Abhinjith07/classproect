import 'package:firebase/login.dart';
import 'package:firebase/EditPage.dart';
import 'package:firebase/Signup.dart';
import 'package:firebase/imagePIcker/imagePicker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '';
import 'firebase_options.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignupPage(),
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      theme:ThemeData(colorScheme:
      ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
    useMaterial3: true,

      ),
    );
  }
}
