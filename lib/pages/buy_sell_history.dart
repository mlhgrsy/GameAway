import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gameaway/services/order.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/buy_history.dart';
import 'package:gameaway/views/history_card.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:gameaway/views/sell_history.dart';

class BuySellHistory extends StatefulWidget {
  const BuySellHistory({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _BuySellHistoryState createState() => _BuySellHistoryState();
}

class _BuySellHistoryState extends State<BuySellHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: kAppBarTitleTextStyle,
          toolbarHeight: 55,
          centerTitle: true,
          title: const Text("Buy/Sell History"),
          backgroundColor: AppColors.primaryBackground,
          elevation: 0.0,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Bought"),
              Tab(text: "Sold"),
            ],
          ),
        ),
        body: TabBarView(
          children: [BuyHistory(uid: widget.uid), SellHistory(uid: widget.uid)],
        ),
      ),
    );
  }
}
