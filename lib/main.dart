import 'package:flutter/material.dart';
import 'package:gameaway/pages/homepage.dart';
import 'package:gameaway/root.dart';
import 'package:gameaway/pages/sign_up.dart';
import 'package:gameaway/pages/walkthrough.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/product_preview.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => const Root(),
      '/walk': (context) => const WalkThrough(),
      '/signUp': (context) => const SignUp()
    },
  ));
}
