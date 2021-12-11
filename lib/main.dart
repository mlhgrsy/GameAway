import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/homepage.dart';
import 'package:gameaway/root.dart';
import 'package:gameaway/pages/sign_up.dart';
import 'package:gameaway/pages/walkthrough.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/product_preview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppInitialization());
}

class AppInitialization extends StatefulWidget {
  const AppInitialization({Key? key}) : super(key: key);

  @override
  _AppInitializationState createState() => _AppInitializationState();
}

class _AppInitializationState extends State<AppInitialization> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                    'No Firebase Connection: ${snapshot.error.toString()}'),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: const Root(),
            routes: {
              '/walk': (context) => const WalkThrough(),
              '/signUp': (context) => const SignUp()
            },
          );
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Connecting to Firebase'),
            ),
          ),
        );
      },
    );
  }
}
