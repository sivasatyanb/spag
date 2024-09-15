import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, '/auth');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'MarkMyAnswer',
              style: TextStyle(
                color: Color(0xff000054),
                fontSize: 48,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: CircularProgressIndicator(
              color: Color(0xffCF4520),
              strokeWidth: 10,
            ),
          ),
        ],
      ),
    );
  }
}
