import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class LoR extends StatefulWidget {
  const LoR({super.key});

  @override
  State<LoR> createState() => LoRState();
}

class LoRState extends State<LoR> {
  bool showLoginPage = true;

  void togglePages() {
    setState(
      () {
        showLoginPage = !showLoginPage;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return Register(
        onTap: togglePages,
      );
    }
  }
}
