import 'package:gameaway/services/auth.dart';
import 'package:gameaway/services/loading.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  AuthService auth = AuthService();
  String name = "";
  String sur = "";
  String mail = "";
  String pass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SIGN UP',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: Dimen.regularPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: AppColors.DarkTextColor,
                            filled: true,
                            hintText: "Name",
                            hintStyle: kButtonLightTextStyle,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null) {
                              return "Name cannot be empty.";
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty) {
                                return "Name cannot be empty.";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              name = value;
                            }
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: AppColors.DarkTextColor,
                            filled: true,
                            hintText: "Surname",
                            hintStyle: kButtonLightTextStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null) {
                              return "Surname cannot be empty.";
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty) {
                                return "Surname cannot be empty.";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              sur = value;
                            }
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: AppColors.DarkTextColor,
                            filled: true,
                            hintText: "Email",
                            hintStyle: kButtonLightTextStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null) {
                              return "Email cannot be empty.";
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty) {
                                return "Email can not be empty.";
                              }
                              if (!EmailValidator.validate(trimmedValue)) {
                                return "Email is not valid.";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              mail = value;
                            }
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: AppColors.DarkTextColor,
                          filled: true,
                          hintText: "Password",
                          hintStyle: kButtonLightTextStyle,
                          border: OutlineInputBorder(
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
                            return "Password cannot be empty.";
                          } else {
                            String trimmedValue = value.trim();
                            if (trimmedValue.isEmpty) {
                              return "Password cannot be empty.";
                            }
                            if (trimmedValue.toLowerCase() == trimmedValue) {
                              return "There must be upper case letter in the password.";
                            }
                            if (trimmedValue.toUpperCase() == trimmedValue) {
                              return "There must be lower case letter in the password.";
                            }
                            if (trimmedValue.length < 6) {
                              return "Password must have at least 6 characters.";
                            }
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) {
                            pass = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            Provider.of<Loading>(context, listen: false)
                                .increment();
                            if (await auth.signupWithMailAndPass(
                                    mail, pass, name, sur) ==
                                null) {
                              Provider.of<Loading>(context, listen: false)
                                  .decrement();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text(
                                            "Account Creation Error"),
                                        content: const Text(
                                            "An error occurred. Someone else may already be using this email"),
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
                              Provider.of<Loading>(context, listen: false)
                                  .decrement();
                              FocusScope.of(context).unfocus();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text(
                                            "Account Creation Successful"),
                                        content: const Text(
                                            "Your account has been created"),
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
                          }
                        },
                        child: Padding(
                          padding: Dimen.smallPadding,
                          child: Text(
                            'Sign Up ',
                            style: kButtonDarkTextStyle,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: Dimen.smallPadding,
                        child: Text(
                          'By signing up, you agree with the Terms of Service and Privacy Policy ',
                          style: kButtonLightTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                                child: Text("Already have an account",
                                    style: kButtonLightTextStyle))))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
