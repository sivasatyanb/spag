import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: const Color(0xff000054),
                  child: Center(
                    child: Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    'MarkMyAnswer is an AI-powered tool that assists you to check for spelling and grammar mistakes in your writing.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/tutorial');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffCF4520),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                    child: Text(
                      'Let\'s go!',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
