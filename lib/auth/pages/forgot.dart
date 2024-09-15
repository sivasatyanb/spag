// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/textfield.dart';
import '../components/button.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});
  @override
  State<Forgot> createState() => ForgotState();
}
// initialises the page and variables:
class ForgotState extends State<Forgot> {
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }
// function for firebase to send password reset email in correct format
  Future passwordReset() async {
    if (_emailController.text.trim() == _confirmEmailController.text.trim()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              content: Text(
                'The password reset link has been sent! Check your email.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }),
        );
        // error handling:
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              content: Text(
                e.message.toString(),
              ),
            );
          }),
        );
      }
      
    } else {
      showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            content: Text(
              'The emails do not match.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff000054),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              color: const Color(0xff000054),
              child: const Center(
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Text(
                'Enter your email below to send a link to your inbox. Follow the provided instructions in that email to change your password. After that, you can now login with your new credentials.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 25),
            Textfield(
              controller: _emailController,
              hintText: 'Enter your email',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            Textfield(
              controller: _confirmEmailController,
              hintText: 'Confirm your email',
              obscureText: false,
            ),
            const SizedBox(height: 25),
            Button(
              onTap: passwordReset,
              text: 'Reset your password',
            ),
          ],
        ),
      ),
    );
  }
}
