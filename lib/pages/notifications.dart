import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameaway/services/db.dart';
import 'package:gameaway/views/loading_indicator.dart';

class notify extends StatefulWidget {
  const notify({Key? key}) : super(key: key);

  @override
  _notifyState createState() => _notifyState();
}

class _notifyState extends State<notify> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    var uid = auth.currentUser!.uid;
    var loguser = users.doc(uid);
    var notify = loguser.collection("notification");
    bool state = false;
    DBService db = DBService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.primaryBackground,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: notify.snapshots(),
              builder: (context, AsyncSnapshot asyncSnapshot) {
                if (!asyncSnapshot.hasData) return const LoadingIndicator();
                print(asyncSnapshot.data.docs);
                List<DocumentSnapshot> listofnotify = asyncSnapshot.data.docs;
                return Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    height: double.infinity,
                    color: AppColors.primary,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listofnotify.length,
                      itemBuilder: (context, index) {
                        if (listofnotify != null) {
                          return Padding(
                            padding: Dimen.listPadding,
                            child: Card(
                              color: AppColors.captionColor,
                              child: ListTile(
                                onTap: () {},
                                title: Text(
                                  '${listofnotify[index]["notify"]}',
                                  style: kButtonDarkTextStyle
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    //if(notify.get())
                                    print(listofnotify[index]["notify"]);
                                    await listofnotify[index]
                                        .reference
                                        .delete();
                                    //listofnotify[index]["notify"].delete();
                                  },
                                  icon: Icon(Icons.delete),
                                  color: AppColors.notification,
                                  iconSize: 30,
                                ),
                                leading: const IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.arrow_right_alt_rounded, color: AppColors.notification),
                                  iconSize: 25,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(child: Text("No notifications"));
                        }
                      },
                    ),
                  ),
                );
              }),


          // mock send notification
          /*OutlinedButton(
              onPressed: () => db.addnotif("A notification has been send"),
              child: Text("Send notification"))*/
        ],
      ),
    );
  }

  Future findnotif() async {
    CollectionReference users = _firestore.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    var email = await auth.currentUser!.email;
    var loguser = await users.doc(email);
    //var response =  loguser.get();
    var notify = loguser.collection("notifications");
    return notify;
  }
}
