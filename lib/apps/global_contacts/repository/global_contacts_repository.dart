import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<QuerySnapshot<Map<String, dynamic>>> getContacts() async {
    var userCollection = await firestore.collection('users').get();
    return userCollection;
  }

  // void selectContact(Contact selectedContact, BuildContext context) async {
  //   try {
  //     var userCollection = await firestore.collection('users').get();
  //     bool isFound = false;

  //     for (var document in userCollection.docs) {
  //       var userData = UserModel.fromMap(document.data());
  //       String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
  //         ' ',
  //         '',
  //       );
  //       if (selectedPhoneNum == userData.phoneNumber) {
  //         isFound = true;
  //         Navigator.pushNamed(
  //           context,
  //           MobileChatScreen.routeName,
  //           arguments: {
  //             'name': userData.name,
  //             'uid': userData.uid,
  //           },
  //         );
  //       }
  //     }
  // if (!isFound) {
  //       showSnackBar(
  //         context: context,
  //         content: 'This number does not exist on this app.',
  //       );
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }
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
            },
          );
    }

      
}