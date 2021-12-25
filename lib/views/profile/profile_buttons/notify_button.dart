import 'package:flutter/material.dart';
import 'package:gameaway/utils/colors.dart';

class NotificationButtons extends StatefulWidget {
  const NotificationButtons({Key? key}) : super(key: key);

  @override
  _NotificationButtonsState createState() => _NotificationButtonsState();
}

class _NotificationButtonsState extends State<NotificationButtons> {
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
                Icon(Icons.notifications),
                Text("Notification Settings"),
                Icon(Icons.arrow_forward)
              ],
            ),
            onPressed: () {}, // burası sayfaya göre doldurulacak
          ),
        )
    );
  }
}
