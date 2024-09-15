// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'service.dart';
import '../components/button.dart';
import '../components/textfield.dart';
import '../components/tile.dart';
import '../../home/pages/home.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({
    super.key,
    required this.onTap,
  });
  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isTermsAccepted = false;

  // method to create a new user - doesn't take in any parameters so void
  void signUserUp() async {
    // only proceed if terms and conditions are accepted
    if (!_isTermsAccepted) {
      showErrorMessage('Please accept the terms and conditions');
      return;
    }
    // calling another method to display loading screen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      // confirm the 'password' and 'confirm password' fields are identical
      if (passwordController.text == confirmPasswordController.text) {
        // creates a new user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // route to auth page (for validation) and then home page
        Navigator.of(context).pushNamed('/auth');
      } else {
        // calling another method to display error message to user
        showErrorMessage('Passwords don\'t match!');
      }
    // returning any other error message that firebase has to user
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          title: Center(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      },
    );
  }

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
                  'Register',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Textfield(
              controller: emailController,
              hintText: 'Enter your email',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            Textfield(
              controller: passwordController,
              hintText: 'Enter your password',
              obscureText: true,
            ),
            const SizedBox(height: 15),
            Textfield(
              controller: confirmPasswordController,
              hintText: 'Confirm your password',
              obscureText: true,
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 4,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Checkbox(
                  value: _isTermsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTermsAccepted = value ?? false;
                    });
                  },
                ),
                Text(
                  'By creating an account, I accept the',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () {
                    // ignore: deprecated_member_use
                    launch(
                      'https://www.google.com/',
                    );
                  },
                  child: const Text(
                    'terms',
                    style: TextStyle(
                      color: Color(0xffCF4520),
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  'and',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () {
                    // ignore: deprecated_member_use
                    launch(
                      'https://www.google.com/',
                    );
                  },
                  child: const Text(
                    'conditions',
                    style: TextStyle(
                      color: Color(0xffCF4520),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Button(
              text: 'Register',
              onTap: signUserUp,
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Color(0xff000054),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'or continue with',
                      style: TextStyle(
                        color: Color(0xff000054),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Color(0xff000054),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tile(
                  onTap: () => Service().signInWithGoogle(context).then(
                    (widget) {
                      if (widget is Home) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => widget,
                          ),
                        );
                      } else {
                        showErrorMessage('Try again');
                      }
                    },
                  ),
                  imagePath: 'assets/images/google.png',
                ),
              ],
            ),
            const SizedBox(height: 15),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff000054),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffCF4520),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
