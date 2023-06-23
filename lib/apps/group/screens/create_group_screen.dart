import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/widgets/user_picker_image.dart';
import 'package:p_chat/apps/group/controller/group_controller.dart';
import 'package:p_chat/apps/group/widgets/group_select_contacts.dart';
import 'package:p_chat/common/utils/colors.dart';
import 'package:uuid/uuid.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});
  static const String routeName = '/create-group';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {

  TextEditingController groupNameController = TextEditingController();
  File? _selectedImage;



  void createGroup() async{
    var groupId = const Uuid().v1();
    String profileUrl = "";
    if (_selectedImage != null){
      final storageRef = FirebaseStorage.instance
            .ref()
            .child('/group/$groupId',);
        await storageRef.putFile(_selectedImage!);
      profileUrl = await storageRef.getDownloadURL();
    }
    if (groupNameController.text.trim().isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            profileUrl,
            groupId,
            ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.state).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Group",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            UserImagePicker(
                  onPickImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Group Name',
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}