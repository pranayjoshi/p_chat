import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/controller/auth_controller.dart';
import 'package:p_chat/apps/auth/widgets/user_picker_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/common/utils/colors.dart';

import '../../../models/user.dart';

final _firebase = FirebaseAuth.instance;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = "/profile";

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  // var isLogin = true;
  var _isUploading = false;
  UserModel? _userData;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  var _defaultImageUrl = "";

  var userExists = false;

  Future<bool> usernameExists(String username) async {
    // print(_userData!.username);
    if (_userData!.username == username){
      return false;
    }
    final stat = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get()
        .then((value) => value.size > 0 ? true : false);
    // print(stat);
    return stat;
  }

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
    );
  }

  Future<void> setFields() async {
    // print("hello");
    final userData = await ref.read(authControllerProvider).getUserData();
    if (userData == null) {
      _userData = UserModel(
      name: '',
      username: '',
      uid: '',
      profilePic: '',
      isOnline: false,
      email: '',
      // groupId: [],
    );
    }else {_userData = userData;}

    
    

    _usernameController.text =  _userData!.username;
    _nameController.text = _userData!.name;
    setState(() {
      _defaultImageUrl = _userData!.profilePic;
    });
    // print("hehehes");
    // print(_defaultImageUrl);

    // print(_defaultImageUrl);
  }

  void storeUserData() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formkey.currentState!.save();
    ref.read(authControllerProvider).saveUserDataToFirebase(
          context,
          _nameController.text,
          _usernameController.text,
          _selectedImage,
        );
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
      Map<String, dynamic>? data = {"": ""};

      final documentSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .get();
      if (documentSnap.exists) {
        Map<String, dynamic>? data = documentSnap.data();
        var value = data?['username'];
        var value2 = data?['username'];
        // _usernameController.text = value; // <-- The value you want to retrieve.
        _defaultImageUrl = value2;
        // Call setState if needed.
      }
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
    Future.delayed(Duration.zero,() async {await setFields();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
          title: Text(
            "Profile",
            style: TextStyle(color: textColor),
          )),
      backgroundColor: backgroundColor,
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
                if (_defaultImageUrl != "")
                UserImagePicker(
                  onPickImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
                  defaultImageUrl: _defaultImageUrl,
                ) else UserImagePicker(
                  onPickImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
                  defaultImageUrl: _defaultImageUrl,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(bottom: 8), child: Text("Your Name", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)),
                  TextFormField(
                    style: TextStyle(color: textColor),
                    cursorColor: textColor,
                    decoration: textFieldDesign(
                        "Enter your Full Name", Icons.person_2_outlined),
                    enableSuggestions: false,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.trim().length < 4 ||
                          value.trim().length > 32 ||
                          value.isEmpty) {
                        // print(value);
                        return 'Please enter valid username!';
                      }
                      return null;
                    },
                    controller: _nameController,
                  ),
                SizedBox(
                  height: 20,
                ),
                Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(bottom: 8), child: Text("Your Username", style: TextStyle( fontWeight: FontWeight.w500, fontSize: 16),)),
                TextFormField(
                  style: TextStyle(color: textColor),
                  cursorColor: textColor,
                  decoration: textFieldDesign(
                      "Enter your Username", Icons.account_circle_rounded),
                  enableSuggestions: false,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (text) async {
                    final check = await usernameExists(text);
                    setState(() => userExists = check);
                    // print(userExists);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.trim().length < 4 ||
                        value.trim().length > 32 ||
                        value.contains(" ") ||
                        value.isEmpty) {
                      // print(value);
                      return 'Please enter valid username!';
                    }
                    if (userExists) return 'Username Already Exists!';
                    return null;
                  },
                  controller: _usernameController,
                ),
                SizedBox(
                  height: 30,
                ),
                if (_isUploading)
                  const CircularProgressIndicator(),
                if (!_isUploading)
                  ElevatedButton(
                    onPressed: () {
                      storeUserData();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor, foregroundColor: textColor),
                    child: Text("Submit"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
