import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/profile_buttons/account_button.dart';
import 'package:gameaway/views/profile_buttons/history_button.dart';
import 'package:gameaway/views/profile_buttons/notify_button.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.ytimg.com/vi/tZp8sY06Qoc/maxresdefault.jpg'), //burası pp widget fnc yazılacak
            ),
          const SizedBox(height: 30),

          Text("Name Surname",
            style: kProfileNameText,),

          const SizedBox(height: 10),

          Text("mail@email.com",
            style: kProfileMailText,
          ),

          const SizedBox(height: 15),

          AccountButtons(),

          HistoryButtons(),

          NotificationButtons(),
        ],
      ),
    );
  }
}

//yapılması gerekenler: profile ad, soyad ve maili database den almak, deafult pp atamak