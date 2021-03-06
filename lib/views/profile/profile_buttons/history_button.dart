import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/buy_sell_history.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:provider/provider.dart';

class HistoryButtons extends StatefulWidget {
  const HistoryButtons({Key? key}) : super(key: key);

  @override
  _HistoryButtonsState createState() => _HistoryButtonsState();
}

class _HistoryButtonsState extends State<HistoryButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SizedBox(
          width: 1000,
          height: 60,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.primary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.history),
                Text("Buy/Sell History"),
                Icon(Icons.arrow_forward)
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuySellHistory(
                            uid: Provider.of<User?>(context)!.uid,
                          )));
            }, // burası sayfaya göre doldurulacak
          ),
        ));
  }
}
