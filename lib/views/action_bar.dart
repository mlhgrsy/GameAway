import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/mock_payment.dart';
import 'package:gameaway/pages/notifications.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:provider/provider.dart';

class ActionBar extends StatelessWidget with PreferredSizeWidget {
  ActionBar({Key? key, this.title = "GameAway"}) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              if (user != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => notify()));
              }
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.red,
              size: 40,
            ))
      ],
      title: Text(
        title,
      ),
      backgroundColor: AppColors.primaryBackground,
      centerTitle: true,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
