import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingsPP extends StatefulWidget {
  const AccountSettingsPP({Key? key}) : super(key: key);

  @override
  _AccountSettingsPPState createState() => _AccountSettingsPPState();
}

class _AccountSettingsPPState extends State<AccountSettingsPP> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
          String filename = basename(image!.path);
          FirebaseStorage.instance
              .ref()
              .child("/profileImages/$filename")
              .putFile(File(image!.path));
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(""),
            ),
            Icon(
              Icons.edit,
              size: 50,
              color: Colors.black.withOpacity(.3),
            ),
          ],
        ),
      ),
    );
  }
}
