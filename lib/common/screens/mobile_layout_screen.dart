import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/apps/auth/screens/auth.dart';
import 'package:p_chat/apps/auth/screens/profile.dart';
import 'package:p_chat/colors.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  Future logout() async {
    await FirebaseAuth.instance.signOut();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          "Chat",
          style: TextStyle(color: textColor),
        ),
        actions: [
          IconButton(
              color: textColor,
              onPressed: () {
                logout(); Navigator.pop(context);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(child: ElevatedButton(child: Text('Mobile!'), onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
      },),
    ));
  }
}
