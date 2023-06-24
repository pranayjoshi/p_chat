import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/chat/screens/mobile_chat_screen.dart';
import 'package:p_chat/models/user.dart';
import 'package:p_chat/common/utils/utils.dart';
import 'package:p_chat/models/user.dart';
import 'package:p_chat/apps/chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getContacts() async {
    var userCollection = await firestore.collection('users').snapshots();
    return userCollection;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getChatContacts() async {
    var userCollection = await FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> contacts = userCollection.docs; 

    return contacts;
  }
    void selectContact(UserModel selectedUserData, BuildContext context) async{
      // var userCollection = await firestore.collection('users').get();
      // for (var document in userCollection.docs) {
      //   var userData = UserModel.fromMap(document.data());
      // }
      Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              'name': selectedUserData.name,
              'uid': selectedUserData.uid,
              'profilePic': selectedUserData.profilePic,
              'isGroupChat': false,
            },
          );
    }

      
}