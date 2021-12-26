import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/views/action_bar.dart';

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
  double price = 0;
  double rating = 0;
  dynamic seller = null;
  String tag = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ActionBar(title: "Sell Product"),
        body: Center(
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
                      if (value != null) price = double.parse(value);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "rating"),
                    onSaved: (value) {
                      if (value != null) rating = double.parse(value);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "seller"),
                    onSaved: (value) {
                      if (value != null) seller = value;
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
        floatingActionButton: FloatingActionButton(
          child: Text('Add'),
          onPressed: () async {
            _formProductKey.currentState!.save();
            db.addProduct(category, name, picture, price, rating, "",
                tag); //seller null yerine eklenecek !!!!
          },
        ));
  }
}
