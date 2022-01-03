
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gameaway/pages/homepage/homepage.dart';
import 'package:gameaway/pages/mock_payment.dart';
import 'package:gameaway/pages/notifications.dart';
import 'package:gameaway/pages/oldpurchase.dart';
import 'package:gameaway/pages/profile/account_settings.dart';
import 'package:gameaway/pages/sign_in.dart';
import 'package:gameaway/root.dart';
import 'package:gameaway/pages/sign_up.dart';
import 'package:gameaway/pages/walkthrough.dart';
import 'package:gameaway/services/auth.dart';
import 'package:gameaway/services/bottom_nav.dart';
import 'package:gameaway/utils/dimensions.dart';
import 'package:gameaway/utils/styles.dart';
import 'package:gameaway/views/product_preview.dart';
import 'package:provider/provider.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
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
          return BaseApp();
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

class BaseApp extends StatelessWidget {
  const BaseApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: AuthService().user,
        ),
        ChangeNotifierProvider(create: (_) => BottomNav())
      ],
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        home: Root(analytics: analytics, observer: observer),
        routes: {
          '/walk': (context) => const WalkThrough(),
          '/signUp': (context) => const SignUp(),
          '/signIn': (context) => const SignIn(),
          '/Notify': (context) => const notify(),
          '/profile/account_settings': (context) => const AccountSettings(),
          '/mock_payment': (context) => const Paymentscreen(),
          '/old_purchase': (context) => const oldpurchase(),
        },
      ),
    );
  }
}
