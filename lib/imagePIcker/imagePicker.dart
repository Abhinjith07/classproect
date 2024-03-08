import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImgPick extends StatefulWidget {
  const ImgPick({Key? key}) : super(key: key);

  @override
  State<ImgPick> createState() => _ImgPickState();
}

class _ImgPickState extends State<ImgPick> {
  List<File> _images = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask = _storage.ref().child('images/$imageName.jpg').putFile(image);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded to Firebase: $downloadUrl');
    } catch (e) {
      print('Error uploading image to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(55.0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 30,),
                  children: [
                  TextSpan(
                  text: 'Pho',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'to',
                  style: TextStyle(color: Colors.orangeAccent),
                )
                ],
              ),
            ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(27.0),
                    topRight: Radius.circular(27.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 9.0,
                      mainAxisSpacing: 9.0,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.file(_images[index], fit: BoxFit.cover),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          var ImgPick =
          await ImagePicker().pickImage(source: ImageSource.gallery);
          if (ImgPick != null) {
            setState(() {
              _images.add(File(ImgPick.path));
            });
            _uploadImageToFirebase(File(ImgPick.path));
          }
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}