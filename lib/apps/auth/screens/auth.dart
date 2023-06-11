import 'dart:io';

import 'package:p_chat/apps/auth/widgets/user_picker_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/colors.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formkey = GlobalKey<FormState>();
  var isLogin = true;
  var _enteredEmail = "";
  var _enteredPass = "";
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
        labelStyle: TextStyle(color: textColor.withOpacity(.8)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor),
            borderRadius: BorderRadius.circular(30).copyWith(
                bottomRight: Radius.circular(0), topLeft: Radius.circular(0))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor),
            borderRadius: BorderRadius.circular(30).copyWith(
                bottomRight: Radius.circular(0), topLeft: Radius.circular(0))));
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
      if (isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        var imageUrl = "";
        if (!isLogin && _selectedImage == null) {
          imageUrl = 'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
        }else {
          await storageRef.putFile(_selectedImage!);
          
          imageUrl = await storageRef.getDownloadURL();
        }
        // print(imageUrl);

        final username = await FirebaseFirestore.instance.collection("users").where("username", isEqualTo: _enteredUsername).get().then((value) => value.size > 0 ? true : false);
        print("hiiidawdW");
        print(username);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredentials.user!.uid)
            .set({
          "username": _enteredUsername,
          "email": _enteredEmail,
          "isOnline": true,
          "image_url": imageUrl
        });
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message ?? "Authentication Failed!")));
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
              width: 200,
              child: Image.asset("assets/img/chat.png"),
            ),
            Card(
              color: Theme.of(context).colorScheme.primary,
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isLogin)
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
                          decoration:
                              textFieldDesign("Enter your Email", Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return 'Please enter valid Email id!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        if (!isLogin)
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
                        TextFormField(
                          style: TextStyle(color: textColor),
                          cursorColor: textColor,
                          decoration: textFieldDesign(
                              "Enter your Password", Icons.password),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be 6 characters Long!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPass = value!;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        if (_isUploading) CircularProgressIndicator(),
                        if (!_isUploading)
                          ElevatedButton(
                              onPressed: () {
                                _submit();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: containerColor),
                              child: isLogin ? Text("Login") : Text("Sign Up")),
                        if (!_isUploading)
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: isLogin
                                  ? Text(
                                      "Create an Account",
                                      style: TextStyle(color: textColor),
                                    )
                                  : Text("Login instead",
                                      style: TextStyle(color: textColor))),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
