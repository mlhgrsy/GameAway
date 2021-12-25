

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/notifications.dart';
import 'package:gameaway/services/auth.dart';
import 'package:provider/provider.dart';
class ActionBar extends StatelessWidget with PreferredSizeWidget {
  const ActionBar({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    final user = Provider.of<User?>(context);
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              if(user !=null) {
                print(User);
                Navigator.push(context,MaterialPageRoute(builder: (context) =>notify()));
              }
              },
            icon: const Icon(
              Icons.notifications,
              color: Colors.red,
              size: 40,
            ))
      ],
      title: const Text(
        'GameAway',
      ),
      backgroundColor: Colors.green,
      centerTitle: true,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);

}





