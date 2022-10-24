import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mynotify/presentation/widgets/auth/login_form.dart';

import '../../../constants/app_colors.dart';
import '../../../logic/database/authentication_helper.dart';
import '../../widgets/auth/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    //main section
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: screen.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //column for image and heading
              Column(
                children: [
                  //illustration image for sign up
                  SvgPicture.asset(
                    'assets/images/illustrations/forgot_password.svg',
                    height: screen.height * .25,
                  ),
                  const SizedBox(height: 5),
                  //Heading
                  Container(
                    width: screen.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          // color: appColors.primaryColor,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              //column for forgot password form
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child:
                      const SingleChildScrollView(child: ForgotPasswordForm()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
