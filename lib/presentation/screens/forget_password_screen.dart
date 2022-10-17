import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/database/authentication_helper.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  String _email = '';
  String status = '';
  String message = '';

  //main part
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    AuthenticationHelper authenticationHelper =
        AuthenticationHelper(parentContext: context);

    //checking for email
    void checkEmail() async {
      FocusScope.of(context).unfocus();
      final valid = formKey.currentState!.validate();
      if (valid) {
        formKey.currentState!.save();
        final data = await authenticationHelper.resetPassword(email: _email);
        setState(() {
          status = data;
        });
        if (data.toString().contains('success')) {
          Future.delayed(const Duration(seconds: 10), () {
            Navigator.of(context).pop();
          });
        }
      }
    }

    if (status.isNotEmpty) {
      if (status.contains('user-not-found')) {
        message = 'User with this email address not found.';
      } else if (status.contains('success')) {
        message = 'Password reset instructions has been sent through email.';
      } else {
        message = 'Something went wrong. Try again';
      }
    }

    //main part
    return Scaffold(
      backgroundColor: appColors.primaryColor,
      appBar: AppBar(
        backgroundColor: appColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          splashRadius: 20.0,
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //email
              TextFormField(
                cursorColor: Colors.white,
                key: const ValueKey('emailaddress'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                //validation
                validator: (data) {
                  if (data!.isEmpty) {
                    return 'Enter an email';
                  } else if (!EmailValidator.validate(data)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value.toString().trim();
                  print('value is $_email');
                },
                style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                //decoration
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Enter email address',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(.7),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.white.withOpacity(.6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1, color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //reset button
              ElevatedButton(
                onPressed: () {
                  checkEmail();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: appColors.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //showing status
              message.trim() != ''
                  ? message.contains('Password reset instructions')
                      ? Column(
                          children: [
                            Text(
                              message,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'NOTE: Check Spam or Junk folder if mail not found in inbox.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Text(
                          message,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                  : const SizedBox(),
              const SizedBox(height: 40),
              status.trim() == 'success'
                  ? const Text(
                      "Redirecting to login screen within in 10 seconds",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
