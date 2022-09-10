import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            FirebaseAuth.instance.currentUser!.uid.toString(),
          ),
        ),
      ),
    );
  }
}
