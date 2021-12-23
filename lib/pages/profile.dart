import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/services/bottom_nav.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    return Column(children: [
      const Text("Profile"),
      OutlinedButton(
          onPressed: () {
            auth.signOut();
            Provider.of<BottomNav>(context,listen: false).switchTo(0);
          },
          child: const Text("Logout"))
    ]);
  }
}
