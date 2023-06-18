// import 'package:p_chat/apps/auth/controller/auth_controller.dart';
import 'package:p_chat/apps/auth/screens/profile.dart';
// import 'package:p_chat/apps/auth/widgets/user_picker_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/common/utils/colors.dart';

final _firebase = FirebaseAuth.instance;
var _instance = FirebaseFirestore.instance;

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

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formkey.currentState!.save();
    try {
      setState(() {
        _isUploading = true;
      });
      if (isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);
        print(userCredentials);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPass);

        print(userCredentials);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      }
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
                        SizedBox(
                          height: 12,
                        ),
                        if (!_isUploading)
                          isLogin
                              ? Text(
                                  "Login",
                                  style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.w600),
                                )
                              : Text("Sign Up",
                                  style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 24,
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
                        if (_isUploading)
                          Center(child: const CircularProgressIndicator()),
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
