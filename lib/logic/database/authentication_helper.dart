import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../services/firebase_services.dart';

class AuthenticationHelper {
  final BuildContext parentContext;
  AuthenticationHelper({required this.parentContext});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({required String email, required String password}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((result) {
        parentContext.read<AuthenticationCubit>().loggingWithCloud();

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
      }
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) {
        parentContext.read<AuthenticationCubit>().loggingWithCloud();
        //navigating to homescreen
        Navigator.of(parentContext)
            .pushNamedAndRemoveUntil('/home', (Route route) => false);
      });
    } on FirebaseAuthException catch (e) {
      if (e.toString().contains('user-not-found')) {
        showTopSnackBar(
          parentContext,
          const CustomSnackBar.error(
            message: "No user with this email address",
          ),
        );
      } else if (e.toString().contains('wrong-password')) {
        showTopSnackBar(
          parentContext,
          const CustomSnackBar.error(
            message: "Password is invalid",
          ),
        );
      }
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }
}
