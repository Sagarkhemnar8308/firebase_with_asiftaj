import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tech/realtimedatabase/view/auth/login_screen.dart';
import 'package:flutter/material.dart';

import '../../firestroredatabase/firestore_list.dart';

class SplachServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FireStoreScreen(),
            ));
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      });
    }
  }
}
