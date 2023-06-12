import 'dart:io';

import 'package:p_chat/apps/auth/widgets/user_picker_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/colors.dart';

final _firebase = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  var isLogin = true;
  var _isUploading = false;
  var _enteredUsername = "";

  InputDecoration textFieldDesign(String labelText, IconData icon) {
    return InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: greyColor.withOpacity(.08),
        prefixIcon: Icon(
          icon,
          color: textColor,
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: textColor.withOpacity(.8)),);
  }

  void setFields(){
    
  }

  File? _selectedImage;

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    // if (!isLogin && _selectedImage == null) {
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("Please choose an image!")));
    // }

    _formkey.currentState!.save();
    try {
      setState(() {
        _isUploading = true;
      });
      final currentUser = FirebaseAuth.instance.currentUser;
      final currentUid = currentUser!.uid;
      Map<String, dynamic>? data = {"":""};

      final documentSnap = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUid).get();
      if (documentSnap.exists) {
        print("waawdwawdawd");
        Map<String, dynamic>? data = documentSnap.data();
        var value = data?['username'];
        _enteredUsername = value+"wad"; // <-- The value you want to retrieve. 
        print(value);
        print(_enteredUsername);
        // Call setState if needed.
      }
      print(data);
        // final storageRef = FirebaseStorage.instance
        //     .ref()
        //     .child('user_images')
        //     .child('${userCredentials.user!.uid}.jpg');
        // var imageUrl = "";
        // if (!isLogin && _selectedImage == null) {
        //   imageUrl = 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
        // }else {
        //   await storageRef.putFile(_selectedImage!);
          
        //   imageUrl = await storageRef.getDownloadURL();
        // }
        // // print(imageUrl);

        // final username = await FirebaseFirestore.instance.collection("users").where("username", isEqualTo: _enteredUsername).get().then((value) => value.size > 0 ? true : false);
        // print("hiiidawdW");
        // print(username);

        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(userCredentials.user!.uid)
        //     .set({
        //   "username": _enteredUsername,
        //   "email": _enteredEmail,
        //   "isOnline": true,
        //   "image_url": imageUrl
        // });
      
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message ?? "Authentication Failed!")));
      
    }
    setState(() {
        _isUploading = false;
      });
  }

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
                        SizedBox(
                          height: 12,
                        ),
                          TextFormField(
                            style: TextStyle(color: textColor),
                            cursorColor: textColor,
                            decoration: textFieldDesign("Enter your Username",
                                Icons.account_circle_rounded),
                            enableSuggestions: false,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().length < 4 ||
                                  value.trim().length > 32 ||
                                  value.isEmpty) {
                                  print(value);
                                return 'Please enter valid username!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                        SizedBox(
                          height: 12,
                        ),
                        if (_isUploading) Center(child: const CircularProgressIndicator()),
                        if (!_isUploading)
                          ElevatedButton(
                              onPressed: () {
                                _submit();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: containerColor),
                              child: Text("Submit"),),
                      ],
                    ),
                  ),
                ),
              ),
            );
  }
}
