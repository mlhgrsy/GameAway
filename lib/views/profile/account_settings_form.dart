import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_mail.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_name.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_password.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_pp.dart';
import 'package:provider/provider.dart';

import '../loading_indicator.dart';
import 'account_settings_forms/account_settings_delete.dart';

class AccountSettingsForm extends StatefulWidget {
  const AccountSettingsForm({Key? key}) : super(key: key);

  @override
  _AccountSettingsFormState createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimen.regularPadding,
      child: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(Provider.of<User?>(context)!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return const LoadingIndicator();
              return Column(
                  children: getAccountSettingsIfHasProvider(snapshot));
            }),
      ),
    );
  }

  List<Widget> getAccountSettingsIfHasProvider(AsyncSnapshot snap) {
    if (snap.data!["has_provider"]) {
      return const [
        SizedBox(height: 20),
        AccountSettingsPP(),
        SizedBox(height: 20),
        AccountSettingsName(),
        SizedBox(height: 20),
        AccountSettingsDelete(),
        SizedBox(height: 20)
      ];
    } else {
      return const [
        SizedBox(height: 20),
        AccountSettingsPP(),
        SizedBox(height: 20),
        AccountSettingsName(),
        SizedBox(height: 20),
        AccountSettingsMail(),
        SizedBox(height: 20),
        AccountSettingsPassword(),
        SizedBox(height: 20),
        AccountSettingsDelete(),
        SizedBox(height: 20)
      ];
    }
  }
}
