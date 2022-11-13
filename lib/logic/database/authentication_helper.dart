import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/logic/cubit/authentication_cubit.dart';
import 'package:notify/logic/services/firebase_services.dart';
import 'package:notify/presentation/screens/onboarding/user_cloud_event_sync.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AuthenticationHelper {
  final BuildContext parentContext;
  AuthenticationHelper({required this.parentContext});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  FirebaseServices firebaseServices = FirebaseServices();

  //SIGN UP METHOD
  Future signUp({
    required String username,
    required String email,
    required String password,
    required String gender,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((result) {
        parentContext
            .read<AuthenticationCubit>()
            .loggingWithCloud(gender: gender);
        User? user = result.user;
        user!.updateDisplayName(username);

        firebaseServices.createProfile(
            email: email,
            username: username,
            userId: result.user!.uid,
            gender: gender);
        //navigating to homescreen
        Navigator.of(parentContext)
            .pushNamedAndRemoveUntil('/home', (Route route) => false);
      });
    } on FirebaseAuthException catch (e) {
      if (e.toString().contains('email-already')) {
        showTopSnackBar(
          parentContext,
          const CustomSnackBar.error(
            message: "The email address is already in use.",
          ),
        );
        return 'error';
      }
    }
  }

  //SIGN IN METHOD
  Future signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) {
        // parentContext.read<AuthenticationCubit>().loggingWithCloud();
        FirebaseFirestore.instance
            .collection('AllUserEvents')
            .doc(result.user!.uid)
            .get()
            .then((value) {
          final gender = value.get('gender');
          Navigator.of(parentContext).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => UserCloudEventSync(gender: gender),
              ),
              (route) => false);
        });
        //navigating to homescreen
        // Navigator.of(parentContext)
        //     .pushNamedAndRemoveUntil('/user-sync', (Route route) => false);
      });
    } on FirebaseAuthException catch (e) {
      if (e.toString().contains('user-not-found')) {
        showTopSnackBar(
          parentContext,
          const CustomSnackBar.error(
            message: "No user with this email address found",
          ),
        );
        return 'error';
      } else if (e.toString().contains('wrong-password')) {
        showTopSnackBar(
          parentContext,
          const CustomSnackBar.error(
            message: "Invalid password",
          ),
        );
        return 'error';
      }
    }
  }

  //PASSWORD RESET
  //resetting password
  Future<String> resetPassword({required String email}) async {
    String status = 'success';
    await _auth.sendPasswordResetEmail(email: email).then((_) {
      log('auth helper pw reset done ');
    }).catchError((e) {
      log('error in pw reset ${e.toString()}');
      status = e.toString();
    });
    return status;
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }
}
