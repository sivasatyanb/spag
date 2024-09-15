import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../home/pages/home.dart';
import '../../intro/pages/welcome.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Home();
        } else {
          return const Welcome();
        }
      },
    );
  }
}
