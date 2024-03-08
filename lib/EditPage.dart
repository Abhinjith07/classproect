import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required String internship, required String name});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  String? selectedInternship;

  signupAuthenticate(email, name, phone, address, qualification, internship) async {
    try {
      var ref = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: "");
      if (ref.user!.uid != null) {
        print("Account created");
        await registration(name, email, phone, address, ref.user!.uid, qualification, internship);
        await saveUserDataToFirestore(ref.user!.uid);
      }
    } catch (e) {
      print("Authentication exception");
    }
  }

  registration(name, email, phone, address, docid, qualification, internship) async {
    var data = {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "qualification": qualification,
      "internship": internship,
    };
    final ref = FirebaseFirestore.instance.collection("Users").doc(docid).set(data);
  }

  Future<void> saveUserDataToFirestore(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'qualification': qualificationController.text,
        'internship': selectedInternship,
      });
      print('User data saved successfully.');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Edit Page",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 26,
            ),
          ),
        ),
        ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(hint: 'Name', controller: nameController),
                CustomTextField(hint: 'Email', controller: emailController),
                CustomTextField(hint: 'Phone', controller: phoneController),
                CustomTextField(hint: 'Address', controller: addressController),
                CustomTextField(hint: 'Qualification', controller: qualificationController),
                CustomInternshipField(
                  hint: 'Internship',
                  value: selectedInternship,
                  onChanged: (newValue) {
                    setState(() {
                      selectedInternship = newValue;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      signupAuthenticate(
                        emailController.text,
                        nameController.text,
                        phoneController.text,
                        addressController.text,
                        qualificationController.text,
                        selectedInternship,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade300,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: hint,
        ),
      ),
    );
  }
}

class CustomInternshipField extends StatelessWidget {
  const CustomInternshipField({
    Key? key,
    required this.hint,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String hint;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        readOnly: true,
        onTap: () {
          showInternshipDropdown(context);
        },
        controller: TextEditingController(text: value),
      ),
    );
  }

  void showInternshipDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: ListView(
            children: [
              ListTile(
                title: Text('Flutter'),
                onTap: () {
                  onChanged('Flutter');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Python'),
                onTap: () {
                  onChanged('Python');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Data Science'),
                onTap: () {
                  onChanged('Data Science');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
