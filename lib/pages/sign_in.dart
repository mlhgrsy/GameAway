import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameaway/services/loading.dart';
import 'package:gameaway/utils/colors.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/services/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  AuthService auth = AuthService();
  String mail = "";
  String pass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          onSaved: (value) {
                            if (value != null) {
                              mail = value;
                            }
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 25),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          autocorrect: false,
                          onSaved: (value) {
                            if (value != null) {
                              pass = value;
                            }
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState!.save();
                          Provider.of<Loading>(context, listen: false)
                              .increment();
                          auth
                              .signInWithMailAndPass(mail, pass)
                              .then((value) async {
                            if (value == null) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text("Login Error"),
                                        content:
                                            const Text("Invalid Credentials"),
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
                              Navigator.pop(context);
                              Provider.of<Loading>(context, listen: false)
                                  .decrement();
                            }
                          });
                        },
                        child: Padding(
                          padding: Dimen.smallPadding,
                          child: Text(
                            'Sign in ',
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
                SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, '/signUp');
                          });
                        },
                        child: Padding(
                          padding: Dimen.smallPadding,
                          child: Text(
                            "Don't have an account  ",
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
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () async {
                              Provider.of<Loading>(context, listen: false)
                                  .increment();
                              await auth.signInWithGoogle();
                              Provider.of<Loading>(context, listen: false)
                                  .decrement();
                              Navigator.pop(context);
                              String? name =
                                  Provider.of<User?>(context, listen: false)!
                                      .displayName;
                              var snackBar = SnackBar(
                                content: Text('Welcome, $name'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: Padding(
                              padding: Dimen.smallPadding,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.network(
                                      'https://yt3.ggpht.com/ytc/AKedOLSLGq_D1XWmzA-gln_lFj_lxnP2uLlahawMniDurg=s900-c-k-c0x00ffffff-no-rj',
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Continue with Google",
                                        textAlign: TextAlign.center,
                                        style: kButtonDarkTextStyle,
                                      ))
                                ],
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
