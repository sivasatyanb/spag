import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../home/pages/home.dart';

class Service {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Widget> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();
    if (gUser != null) {
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return const Home();
    }
    // ignore: use_build_context_synchronously
    _showErrorDialog(context);
    // ignore: null_argument_to_non_null_type
    return Future.value();
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('An error occurred, please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
