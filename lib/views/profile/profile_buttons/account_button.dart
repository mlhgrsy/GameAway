import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/styles.dart';



class AccountButtons extends StatefulWidget {
  const AccountButtons({Key? key}) : super(key: key);

  @override
  _AccountButtonsState createState() => _AccountButtonsState();
}

class _AccountButtonsState extends State<AccountButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SizedBox(
          width: 1000,
          height: 60,
          child: ElevatedButton (
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.primary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.person),
                Text("Account Settings"),
                Icon(Icons.arrow_forward)
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/profile/account_settings");
            }, // burası sayfaya göre doldurulacak
          ),
        )
    );
  }
}
