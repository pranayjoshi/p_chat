import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/global_contacts/controller/global_contacts_controller.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:p_chat/common/widgets/loader.dart';
import 'package:p_chat/models/user.dart';

import '../../../common/widgets/error.dart';

class GlobalContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/global-contact';
  const GlobalContactsScreen({super.key});

  @override
  ConsumerState<GlobalContactsScreen> createState() =>
      _GlobalContactsScreenState();
}

class _GlobalContactsScreenState extends ConsumerState<GlobalContactsScreen> {
  void selectContact(
      WidgetRef ref, UserModel selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  String username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
        title: TextField(
            decoration: InputDecoration(
                hintText: "Search username...", prefixIcon: Icon(Icons.search)),
            onChanged: (value) {
              setState(() {
                username = value;
              });
            },
          ),
          actions: [
            IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
          ],
        ),
      // body: Center(child: Text("dwada")),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder:(context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                  ?  Loader()
                  :  ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final contact = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return InkWell(
                    // onTap: () => selectContact(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact["username"],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        leading: contact["profilePic"] == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: NetworkImage(contact["profilePic"]),
                                radius: 30,
                              ),
                      ),
                    ),
                  );
                });}),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
      //     ),
    ));
  }
}
