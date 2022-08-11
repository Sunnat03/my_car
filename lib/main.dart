import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:my_car/pages/detail_page.dart';
import 'package:my_car/pages/home_page.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  await runZonedGuarded(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyFirebaseApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyFirebaseApp extends StatelessWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Firebase App",
      navigatorObservers: [routeObserver],
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}