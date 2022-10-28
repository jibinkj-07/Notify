import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../constants/app_colors.dart';
import '../../../logic/cubit/internet_cubit.dart';
import '../../../logic/database/authentication_helper.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool pwObscure = true;
  String _email = '';
  String _password = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  //submit function
  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState!.validate();
    if (valid) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      String error = '';
      try {
        error = await AuthenticationHelper(parentContext: context)
            .signIn(email: _email, password: _password);
      } catch (e) {
        log('error occured in login form');
      }

      if (error.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //main section
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //column for email

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
                  borderSide: BorderSide(width: 1, color: appColors.redColor),
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
            //column for password

            TextFormField(
              cursorColor: appColors.primaryColor,
              key: const ValueKey('password'),
              textInputAction: TextInputAction.done,
              obscureText: pwObscure,
              //validator
              validator: (data) {
                if (data!.isEmpty) {
                  return 'Enter a password';
                } else if (data.length < 6) {
                  return 'Password length must be atleast 6';
                }
              },
              onSaved: (value) {
                _password = value.toString().trim();
              },
              style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              //decoration
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    pwObscure ? Iconsax.eye4 : Iconsax.eye_slash5,
                    size: 20,
                    color: appColors.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      pwObscure = !pwObscure;
                    });
                  },
                  splashColor: appColors.primaryColor.withOpacity(.7),
                  splashRadius: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Password',
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
                  borderSide: BorderSide(width: 1, color: appColors.redColor),
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
            //forgot password section
            InkWell(
              splashColor: appColors.primaryColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                //Going to Forgot password screen
                Navigator.of(context).pushNamed('/forgot-pw');
              },
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: appColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //signup button

            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: appColors.primaryColor,
                      strokeWidth: 1.5,
                    ),
                  )
                : BlocBuilder<InternetCubit, InternetState>(
                    builder: (context, state) {
                      if (state is InternetEnabled) {
                        return Center(
                          child: ElevatedButton(
                            onPressed: _submitForm,
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
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Please turn on Mobile data or Wifi",
                            style: TextStyle(
                              color: appColors.redColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
