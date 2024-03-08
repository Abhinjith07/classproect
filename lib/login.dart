import 'package:firebase/Signup.dart';
import 'package:firebase/imagePIcker/imagePicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  loginAuthenticate(email, password, BuildContext context) async {
    try {
      var ref = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (ref.user != null) {
        print("login success");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ImgPick()),
        );
      } else {
        print("login failed");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid email or password"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Authentication Error: ${e.code}"),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.black,
        title: const Text("Login",style: TextStyle(color:Colors.orangeAccent),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(hint: "Email", controller: emailController, textColor:Colors.white,),
            const SizedBox(height: 20),
            CustomTextField(hint: "Password", controller: passController, textColor: Colors.white,),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.6,
              child: ElevatedButton(
                onPressed: () {
                  loginAuthenticate(emailController.text, passController.text, context);
                },
                child: const Text("Login",style:TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade300,
                  minimumSize: const Size(double.infinity, 50),

              ),
            ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text("Register here",style: TextStyle(color: Colors.orangeAccent),),
            ),
          ],
        ),
      ),
    );
  }
}