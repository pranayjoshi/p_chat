import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/screens/profile.dart';
import 'package:p_chat/common/screens/mobile_layout_screen.dart';

import '../../../common/utils/utils.dart';
import '../../../models/user.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void saveUserDataToFirebase({
    required String name,
    required String username,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String imageUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${uid}.jpg');
        await storageRef.putFile(profilePic!);
        imageUrl = await storageRef.getDownloadURL();
      }

      var user = UserModel(
        username: username,
        name: name,
        uid: uid,
        profilePic: imageUrl,
        isOnline: true,
        email: auth.currentUser!.email!,
        // groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen(),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}