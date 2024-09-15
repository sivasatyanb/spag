import 'package:flutter/material.dart';

class Three extends StatelessWidget {
  const Three({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: const Color(0xff000054),
              child: Center(
                child: Text(
                  'Tutorial',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Step 3: View your previous marks and feedback',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color(0xff000054),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/tutorial3.png',
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'You can check out your previously uploaded work in the history page.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/lor');
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
      ),
    );
  }
}
