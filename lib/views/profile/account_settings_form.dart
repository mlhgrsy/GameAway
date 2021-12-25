import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_mail.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_name.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_password.dart';
import 'package:gameaway/views/profile/account_settings_forms/account_settings_pp.dart';

class AccountSettingsForm extends StatefulWidget {
  const AccountSettingsForm({Key? key}) : super(key: key);

  @override
  _AccountSettingsFormState createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    String pp = "";
    String mail = "";
    return Padding(
      padding: Dimen.regularPadding,
      child: SingleChildScrollView(
        child: Column(
          children: const [
            AccountSettingsPP(),
            AccountSettingsName(),
            AccountSettingsMail(),
            AccountSettingsPassword()
          ],
        ),
      ),
    );
  }
}
