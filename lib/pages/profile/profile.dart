import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/services/bottom_nav.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/views/profile/profile_body.dart';
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
                label: const Text(
                "Log Out",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                  auth.signOut();
                  Provider.of<BottomNav>(context,listen: false).switchTo(0);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.notification),
                ),
              icon: Icon(Icons.logout),
              ),
          ),
          ],
      ),
      body: ProfileBody(), // ana değişiklikler burada olucak

    );

  }
}