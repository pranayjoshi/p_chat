import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/global_contacts/controller/global_contacts_controller.dart';
import 'package:p_chat/common/widgets/error.dart';
import 'package:p_chat/common/widgets/loader.dart';
import 'package:p_chat/models/chat_contact.dart';

final selectedGroupContacts = StateProvider<List<ChatContact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, ChatContact contact) {
    
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);

    } else {
      selectedContactsIndex.add(index);
    }
    // print( selectedContactsIndex);
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getChatContacts() async {
    var userCollection = await FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> contacts = userCollection.docs; 

    return contacts;
  }


  @override
  Widget build(BuildContext context) {
    return ref.watch(getChatContactsProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = ChatContact.fromMap(contactList[index].data());
                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        contact.name,
                      ),
                      leading: CircleAvatar(
                        
                        backgroundImage: NetworkImage(
                          contact.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                        leading: selectedContactsIndex.contains(index)
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.done),
                              )
                            : null,
                      ),
                    ),
                  );
                })
  ),
          error: (err, trace) => ErrorScreen(
            error: err.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}