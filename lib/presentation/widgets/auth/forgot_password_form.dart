import 'dart:developer';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../logic/database/authentication_helper.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String _email = '';
  final _formKey = GlobalKey<FormState>();
  String status = '';
  String message = '';

  //main section
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    AuthenticationHelper authenticationHelper =
        AuthenticationHelper(parentContext: context);

    //submit function
    Future<void> submitForm() async {
      FocusScope.of(context).unfocus();
      final valid = _formKey.currentState!.validate();
      if (valid) {
        _formKey.currentState!.save();
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
        message = 'No user found with this email address';
      } else if (status.contains('success')) {
        message = 'Password reset instructions sent to email.';
      } else {
        message = 'Something went wrong.Try again';
      }
    }
    // log(message);

    return Column(
      children: [
        Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TextFormField(
                  cursorColor: appColors.primaryColor,
                  textInputAction: TextInputAction.next,
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  // obscureText: _isObscure,
                  //validation
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'Provide an email';
                    } else if (!EmailValidator.validate(data)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value.toString().trim();
                  },
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  //decoration
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Email address',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: appColors.primaryColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(width: 1, color: appColors.redColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: appColors.primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                //forgot button
                ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        //showing status
        message.trim() != ''
            ? message.contains('Password reset instructions')
                ? Column(
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Redirecting to Login page in 10 seconds',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'NOTE: Check Spam or Junk folder if not found in inbox.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
            : const SizedBox(),
        //Horizontal line
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 15.0),
                  child: const Divider(
                    color: Colors.black,
                    height: 30,
                  )),
            ),
            const Text("or"),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 15.0, right: 20.0),
                child: const Divider(
                  color: Colors.black,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        //login button
        ElevatedButton(
          onPressed: () {
            //Going to login page
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(.3),
            elevation: 0,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
