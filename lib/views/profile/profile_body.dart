import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/profile/profile_buttons/account_button.dart';
import 'package:gameaway/views/profile/profile_buttons/history_button.dart';
import 'package:gameaway/views/profile/profile_buttons/notify_button.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(Provider.of<User?>(context)!.email)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            String pp = snapshot.data!["picture_url"];
            String name = snapshot.data!["name"];
            String email = snapshot.data!["email"];
            return Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(pp), //burası pp widget fnc yazılacak
                ),
                const SizedBox(height: 30),
                Text(
                  name,
                  style: kProfileNameText,
                ),
                const SizedBox(height: 10),
                Text(
                  email,
                  style: kProfileMailText,
                ),
                const SizedBox(height: 15),
                AccountButtons(),
                HistoryButtons(),
                NotificationButtons(),
              ],
            );
          }),
    );
  }
}

//yapılması gerekenler: profile ad, soyad ve maili database den almak, deafult pp atamak
