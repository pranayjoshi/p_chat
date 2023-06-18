import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_chat/common/utils/colors.dart';


class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, this.radius = 40, required this.onPickImage, this.defaultImageUrl ="https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png"});
  final String defaultImageUrl;
  final double radius;
  final void Function(File pickedImage) onPickImage;
  

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  
  File? _pickedImageFile;
  
  // late String _defaultImageUrl;
  

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
    
    // _defaultImageUrl = widget.defaultImageUrl;
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.defaultImageUrl);
  }

  // @override
  // void initState() {
  //   print("object");
  //   print(widget.defaultImageUrl);
  //   super.initState();
  // }

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
          _pickedImageFile != null ?
            CircleAvatar(
              radius: widget.radius,
              backgroundColor: Colors.grey,
              backgroundImage: FileImage(_pickedImageFile!) ,
            ) :
            CircleAvatar(
              radius: widget.radius,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(widget.defaultImageUrl) ,
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