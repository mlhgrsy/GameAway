import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';

class AccountSettingsPassword extends StatefulWidget {
  const AccountSettingsPassword({Key? key}) : super(key: key);

  @override
  _AccountSettingsPasswordState createState() =>
      _AccountSettingsPasswordState();
}

class _AccountSettingsPasswordState extends State<AccountSettingsPassword> {
  final _formKey2 = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String oldPass = "";
  String newPass = "";

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              decoration: InputDecoration(
                fillColor: AppColors.DarkTextColor,
                filled: true,
                hintText: "Old Password",
                hintStyle: kButtonLightTextStyle,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primary,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              autocorrect: false,
              validator: (value) {
                if (value == null) {
                  return "Please enter your old password";
                } else {
                  String trimmedValue = value.trim();
                  if (trimmedValue.isEmpty) {
                    return "Please enter your old password";
                  }
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  oldPass = value;
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                fillColor: AppColors.DarkTextColor,
                filled: true,
                hintText: "New Password",
                hintStyle: kButtonLightTextStyle,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primary,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              autocorrect: false,
              validator: (value) {
                if (value == null) {
                  return "password can not be empty";
                } else {
                  String trimmedValue = value.trim();
                  if (trimmedValue.isEmpty) {
                    return "password can not be empty";
                  }
                  if (trimmedValue.toLowerCase() == trimmedValue) {
                    return "there must be upper case letter in the password ";
                  }
                  if (trimmedValue.toUpperCase() == trimmedValue) {
                    return "there must be lower case letter in the password ";
                  }
                }
                return null;
              },
              onSaved: (value) {
                if (value != null) {
                  newPass = value;
                }
              },
            ),
            OutlinedButton(
              onPressed: () async {
                if (_formKey2.currentState!.validate()) {
                  _formKey2.currentState!.save();
                  if (await _auth.updatePassword(oldPass, newPass) == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Password Change Error"),
                              content: const Text(
                                  "An error occurred. Please make sure to enter your old password correctly"),
                              actions: [
                                TextButton(
                                  child: const Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                  } else {
                    FocusScope.of(context).unfocus();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Password Change Successful"),
                              content: const Text(
                                  "You can now use your new password to sign in!"),
                              actions: [
                                TextButton(
                                  child: const Text("Okay"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                  }
                }
              },
              child: Padding(
                padding: Dimen.smallPadding,
                child: Text(
                  'Update Password',
                  style: kButtonDarkTextStyle,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ));
  }
}
