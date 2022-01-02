import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:provider/provider.dart';

class SellProduct extends StatefulWidget {
  SellProduct({Key? key}) : super(key: key);

  @override
  State<SellProduct> createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct> {
  DBService db = DBService();
  final _formProductKey = GlobalKey<FormState>();
  String category = "";
  String name = "";
  String picture = "";
  num price = 0;
  num rating = 0;
  dynamic seller = null;
  String tag = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ActionBar(title: "Sell Product"),
        body: SingleChildScrollView(
          child: Container(
            padding: Dimen.regularPadding,
            child: Form(
              key: _formProductKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(hintText: "category"),
                    onSaved: (value) {
                      if (value != null) category = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "name"),
                    onSaved: (value) {
                      if (value != null) name = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "picture"),
                    onSaved: (value) {
                      if (value != null) picture = value;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "price"),
                    onSaved: (value) {
                      if (value != null) price = num.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "tag"),
                    onSaved: (value) {
                      if (value != null) tag = value;
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primaryBackground,
            onPressed: () async {
              var sellerRef = DBService.userCollection.doc(Provider.of<User?>(context,listen: false)!.uid);
              _formProductKey.currentState!.save();
              db.addProduct(category, name, picture, price, sellerRef,
                  tag);
            },
            label: const Text("Add"),
            icon: const Icon(Icons.add)));
  }
}
