import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/views/action_bar.dart';
num sum=0;
class basket extends StatefulWidget {
  const basket({Key? key}) : super(key: key);

  @override
  _basketState createState() => _basketState();
}

class _basketState extends State<basket> {
  @override
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Widget build(BuildContext context) {
    CollectionReference products = _firestore.collection('product');


    return Scaffold(
      appBar: ActionBar(title: "Basket"),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: products.snapshots(),
                builder: (context, AsyncSnapshot asyncSnapshot) {
                  if (!asyncSnapshot.hasData) return const Text("Loading...");
                  print(asyncSnapshot.data.docs);
                  List<DocumentSnapshot> listofnotify = asyncSnapshot.data.docs;
                  num sum_price = 0;
                  int i =0;
                  while(i<listofnotify.length) {
                   sum_price= sum_price + listofnotify[i]["price"];
                   i=i+1;
                  }
                  print(sum_price);
                  print(sum);
                  sum=sum_price;
                  print(sum);

                   return Flexible(
                    fit: FlexFit.loose,
                    child:  Container(
                      height: 475,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: listofnotify.length,
                          itemBuilder: (context, index) {
                            if (listofnotify != null) {
                              return Padding(
                                padding: Dimen.listPadding,
                                child: Card(
                                  child: ListTile(
                                    onTap: () {},
                                    title: Column(
                                      children: [
                                        Text(
                                          '${listofnotify[index]["name"]}',
                                          style: TextStyle(
                                              color: AppColors.notification,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    leading: Image.network(listofnotify[index]["picture"]),
                                    subtitle: Text(
                                        '\$ ${listofnotify[index]["price"]}'),
                                    trailing: Icon(Icons.delete) ,
                                  ),
                                ),
                              );
                            } else {
                              return Center(child: Text("no purchase has been made"));
                            }
                          },

                        ),
                    ),
                    
                  );
                }),
          Text("$sum")]),

    );
  }
}

