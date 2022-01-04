import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/views/action_bar.dart';

import 'mock_payment.dart';
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
                                              color: AppColors.secondary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    leading: Image.network(listofnotify[index]["picture"]),
                                    subtitle: Text(
                                        '\$ ${listofnotify[index]["price"]}',style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: TextButton(onPressed: (){},child: Text("X",style:
                                    TextStyle(color: Colors.red,fontSize: 30),),)
                                    //Icon(Icons.delete,color: Colors.red,) ,
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
          Column(
            children: [
              SizedBox(height: 40,),
              Divider(height: 2,),
              Text("The sum is \$ $sum")]),
            Divider(height: 2,thickness: 3,),
            SizedBox(height: 15,),
            TextButton(onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Paymentscreen(sum: sum)));
            }, child: Text("purchase"))
            ],
          ),


    );
  }
}

