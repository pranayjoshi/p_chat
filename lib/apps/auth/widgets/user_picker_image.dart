import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickImage(_pickedImageFile!); 
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              foregroundImage:_pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
            ),
            Positioned(
                bottom: 0,
                right: -25,
                child: RawMaterialButton(
                  onPressed: pickImage,
                  elevation: 2.0,
                  fillColor: Color(0xFFF5F6F9),
                  child: Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                )),
          ],
        ),
      ),
    );
  }
}