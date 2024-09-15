import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import './firebase_options.dart';
import './splash.dart';
import './info.dart';

import './auth/pages/auth.dart';
import './auth/pages/lor.dart';
import './intro/pages/welcome.dart';
import './intro/components/tutorial.dart';
import './home/pages/home.dart';
import './mark/pages/upload.dart';
import './mark/pages/history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Overlock',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Color(0xff000054),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/lor': (context) => const LoR(),
        '/auth': (context) => const Auth(),
        '/home': (context) => const Home(),
        '/mark': (context) => const Upload(),
        '/welcome': (context) => const Welcome(),
        '/tutorial': (context) => const Tutorial(),
        '/history': (context) => const History(),
        '/info': (context) => const Info(),
      },
    );
  }
}
