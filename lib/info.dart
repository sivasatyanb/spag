import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home/components/draw.dart';

class Info extends StatefulWidget {
  const Info({super.key});
  @override
  State<Info> createState() => InfoState();
}

class InfoState extends State<Info> {
  final user = FirebaseAuth.instance.currentUser!;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff000054),
        elevation: 0,
      ),
      drawer: Draw(
        onSignOut: signUserOut,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              color: const Color(0xff000054),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Info',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'MarkMyAnswer is an AI-powered tool that assists you to check for spelling and grammar mistakes in your writing.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('© 2024 Siva'),
                const SizedBox(height: 1),
                const Text('Version: 3.1.4'),
                const SizedBox(height: 1),
                const Text('Last updated on: 31-Mar-2024'),
                const SizedBox(height: 1),
                GestureDetector(
                  onTap: () {
                    // ignore: deprecated_member_use
                    launch(
                      'https://www.google.com/',
                    );
                  },
                  child: const Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      color: Color(0xffCF4520),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
