import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/profile/profile_buttons/account_button.dart';
import 'package:gameaway/views/profile/profile_buttons/history_button.dart';
import 'package:gameaway/views/profile/profile_buttons/notify_button.dart';
import 'package:provider/provider.dart';

import '../loading_indicator.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Provider.of<User?>(context) == null) return Container();
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(Provider.of<User?>(context)!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            String pp = Provider.of<User?>(context)!.photoURL!;
            String name = Provider.of<User?>(context)!.displayName!;
            String email = Provider.of<User?>(context)!.email!;
            if (!snapshot.hasData) return const LoadingIndicator();
            return Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(pp),
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
                const AccountButtons(),
                const HistoryButtons(),
                // const NotificationButtons(),
              ],
            );
          }),
    );
  }
}

