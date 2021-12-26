import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:provider/provider.dart';

class AccountSettingsMail extends StatefulWidget {
  const AccountSettingsMail({Key? key}) : super(key: key);

  @override
  _AccountSettingsMailState createState() => _AccountSettingsMailState();
}

class _AccountSettingsMailState extends State<AccountSettingsMail> {
  final _formKey = GlobalKey<FormState>();
  String mail = "";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
                initialValue: Provider.of<User?>(context)!.email!,
                decoration: InputDecoration(
                  fillColor: AppColors.DarkTextColor,
                  filled: true,
                  hintText: "Email",
                  hintStyle: kButtonLightTextStyle,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null) {
                    return "Email can not be empty";
                  } else {
                    String trimmedValue = value.trim();
                    if (trimmedValue.isEmpty) {
                      return "Email can not be empty";
                    }
                    if (!EmailValidator.validate(trimmedValue)) {
                      return "Email is not valid";
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null) {
                    mail = value;
                  }
                }),
            OutlinedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  showDialog(
                      context: context,
                      builder: (BuildContext context2) {
                        String pass = "";
                        return AlertDialog(
                          title: const Text("Confirm Action"),
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                const Text(
                                    "Please confirm your identity by providing your password"),
                                const SizedBox(height: 10),
                                TextField(
                                    obscureText: true,
                                    autocorrect: false,
                                    onChanged: (value) {
                                      pass = value;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Your Password"))
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              child: const Text(
                                "Continue",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (await _auth.updateMail(mail, pass) ==
                                    null) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text(
                                                "Email Change Error"),
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
                                  FocusScope.of(context).unfocus();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text(
                                                "Email Change Successful"),
                                            content: const Text(
                                                "Your email has been changed"),
                                            actions: [
                                              TextButton(
                                                child: const Text("Okay"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ]);
                                      });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    AppColors.notification),
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
              child: Padding(
                padding: Dimen.smallPadding,
                child: Text(
                  'Update Email',
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
