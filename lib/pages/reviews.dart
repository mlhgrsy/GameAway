import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/seller_page.dart';
import 'package:gameaway/services/basket.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/services/util.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/action_bar.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key, required this.productID}) : super(key: key);
  final String productID;

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  DBService db = DBService();
  String? _sellerID;
  String productName = "";
  List<String> usernames = [];

  String seller = "";

  Future<List<dynamic>> getReviews() async {
    var reviews =
        (await db.productCollection.doc(widget.productID).get()).get("reviews");
    seller = (await db.productCollection.doc(widget.productID).get())
        .get("seller")
        .id;

    for (int i = 0; i < reviews.length; i++) {
      String name = (await reviews[i]["reviewer"].get()).get("name");
      usernames.add(name);
    }

    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (ActionBar(
        title: "Reviews",
      )),
      body: FutureBuilder(
          future: getReviews(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Icon(Icons.hourglass_full));
            }
            var _reviewlist = snapshot.data;
            if (_reviewlist.isEmpty) {
              return const Center(
                child: Text("There are no reviews for this product"),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _reviewlist.length,
              itemBuilder: (context, index) {
                bool state = _reviewlist[index]["approved"];
                if (state == false &&
                    (((Provider.of<User?>(context) != null &&
                            (!(Provider.of<User?>(context)!.uid == seller)) ||
                        Provider.of<User?>(context) == null))))
                  return Container();
                return Padding(
                  padding: Dimen.listPadding,
                  child: Card(
                    color: Colors.white70,
                    child: ListTile(
                      onTap: () {},
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBarIndicator(
                                rating:
                                    (_reviewlist[index]["rating"]).toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 25.0,
                                unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                              ),
                              Text((usernames[index]), style: kProfileNameText),
                              Visibility(
                                visible: (Provider.of<User?>(context) != null &&
                                    Provider.of<User?>(context)!.uid == seller),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Switch(
                                        value: _reviewlist[index]["approved"],
                                        onChanged: (bool s) async {
                                          print(s);
                                          var new_review =
                                              Map.from(_reviewlist[index]);
                                          print(
                                              "reviewlist ${_reviewlist[index]}");
                                          print("newreviewold $new_review ");
                                          new_review["approved"] = s;
                                          print("newreviewlater $new_review ");
                                          print(
                                              "reviewlistlater ${_reviewlist[index]}");
                                          await db.productCollection
                                              .doc(widget.productID)
                                              .update({
                                            "reviews": FieldValue.arrayRemove(
                                                [_reviewlist[index]])
                                          });
                                          await db.productCollection
                                              .doc(widget.productID)
                                              .update({
                                            "reviews": FieldValue.arrayUnion(
                                                [new_review])
                                          });
                                          setState(() {});
                                        },
                                      ),
                                    ]),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            (_reviewlist[index]["comment"]),
                            style: kProfileMailText,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
