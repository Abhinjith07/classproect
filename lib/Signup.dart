import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/imagePIcker/imagePicker.dart';
import 'package:firebase/login.dart';
import 'package:firebase/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  signupAuthenticate(email, password, name) async {
    try {
      var ref = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (ref.user!.uid != null) {
        print("Account created");
        await registration(name, email, ref.user!.uid);
        await saveUserDataToFirestore(ref.user!.uid);
      }
    } catch (e) {
      print("Authentication exception");
    }
  }

  registration(name, email, String docid) async {
    var data = {
      "name": name,
      "email": email,
    };
    final ref = FirebaseFirestore.instance.collection("Pics").doc(docid).set(data);
  }

  Future<void> saveUserDataToFirestore(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': nameController.text,
        'email': emailController.text,
        'password': passController.text,
      });
      print('User data saved successfully.');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 30,),
                children: [
                  TextSpan(
                    text: 'My',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'Gallery',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(hint: 'Name', controller: nameController, textColor: Colors.white),
                  CustomTextField(hint: 'Email', controller: emailController, textColor: Colors.white),
                  CustomTextField(hint: 'Password', controller: passController, textColor: Colors.white),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        signupAuthenticate(
                          emailController.text,
                          passController.text,
                          nameController.text,
                        );
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>const LoginPage())
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade300,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already logged in?',
                      style: TextStyle(color: Colors.white),),
                      TextButton(onPressed:() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const LoginPage())
                        );
                      },
    child: const Text("Sign in",
          style: TextStyle(color: Colors.orange),
                      )

                      ),
                  ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Color textColor;

  const CustomTextField({required this.hint, required this.controller, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

