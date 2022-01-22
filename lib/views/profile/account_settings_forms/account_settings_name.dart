import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/services/loading.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:provider/provider.dart';

class AccountSettingsName extends StatefulWidget {
  const AccountSettingsName({Key? key}) : super(key: key);

  @override
  _AccountSettingsNameState createState() => _AccountSettingsNameState();
}

class _AccountSettingsNameState extends State<AccountSettingsName> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
                initialValue: Provider.of<User?>(context)!.displayName!,
                decoration: InputDecoration(
                  fillColor: AppColors.DarkTextColor,
                  filled: true,
                  hintText: "Name",
                  hintStyle: kButtonLightTextStyle,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null) {
                    return "name can not be empty";
                  } else {
                    String trimmedValue = value.trim();
                    if (trimmedValue.isEmpty) {
                      return "name can not be empty";
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    name = value;
                  }
                }),
            OutlinedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Provider.of<Loading>(context, listen: false).increment();
                  if (await _auth.updateName(name) == null) {
                    Provider.of<Loading>(context, listen: false).decrement();
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Name Change Error"),
                              content: const Text(
                                  "An error occurred. Please notify admins"),
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
                    Provider.of<Loading>(context, listen: false).decrement();
                    FocusScope.of(context).unfocus();
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Name Change Successful"),
                              content: const Text("Your name has been changed"),
                              actions: [
                                TextButton(
                                  child: const Text("Okay"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                        });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Padding(
                padding: Dimen.smallPadding,
                child: Text(
                  'Update Name',
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
