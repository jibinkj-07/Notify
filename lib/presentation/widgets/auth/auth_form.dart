import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mynotify/logic/database/authentication_helper.dart';
import 'package:mynotify/presentation/screens/forget_password_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../constants/app_colors.dart';
import '../../../logic/cubit/internet_cubit.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.screen,
    required this.parentContext,
  }) : super(key: key);

  final Size screen;
  final BuildContext parentContext;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //variables declaration
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin = false;
  bool _isObscure = true;
  String _email = '';
  String _password = '';
  String _username = '';

  //submit function
  Future<void> _submitForm({required bool signUp}) async {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState!.validate();
    if (valid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      String error = '';
      if (signUp) {
        error = await AuthenticationHelper(parentContext: context)
            .signUp(username: _username, email: _email, password: _password);
      } else {
        error = await AuthenticationHelper(parentContext: context)
            .signIn(email: _email, password: _password);
      }
      log('value of error is $error');
      if (error.isNotEmpty) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //main part
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.only(top: 30),
        // decoration: BoxDecoration(color: Colors.black.withOpacity(.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //profile avatar
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(.2),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Colors.white.withOpacity(.5),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  foregroundColor: appColors.primaryColor,
                  child: const Icon(
                    Iconsax.user,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //user input section
            if (!_isLogin)
              TextFormField(
                cursorColor: Colors.white,
                key: const ValueKey('username'),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                //validation
                validator: (data) {
                  if (data!.isEmpty) {
                    return 'Enter an username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value.toString().trim();
                },
                style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                //decoration
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Enter name',
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
            const SizedBox(height: 10),
            TextFormField(
              cursorColor: Colors.white,
              key: const ValueKey('email'),
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
            const SizedBox(height: 10),
            TextFormField(
              cursorColor: Colors.white,
              key: const ValueKey('password'),
              obscureText: _isObscure,

              //validator
              validator: (data) {
                if (data!.isEmpty) {
                  return 'Enter password';
                } else if (data.length < 6) {
                  return 'Password should have the length atleast 6';
                }
              },
              onSaved: (value) {
                _password = value.toString().trim();
              },
              style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),

              //decoration
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Iconsax.eye4 : Iconsax.eye_slash5,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  splashColor: Colors.white.withOpacity(.7),
                  splashRadius: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: 'Enter password',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(width: 1, color: Colors.white.withOpacity(.6)),
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
            const SizedBox(height: 40),

            //submit buttons
            BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                if (state is InternetEnabled) {
                  return Column(
                    children: [
                      _isLogin
                          ? _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    _submitForm(signUp: false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: appColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 59, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                          : _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    _submitForm(signUp: true);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: appColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                      const SizedBox(height: 15),
                      _isLogin
                          ? Column(
                              children: [
                                //reset button
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        reverseDuration:
                                            const Duration(milliseconds: 300),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        type: PageTransitionType.fade,
                                        child: const ForgetPasswordScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Forget Password?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                //new account button
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Create a new account?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ],
                  );
                } else {
                  return Text(
                    "Enable mobile data or WiFi",
                    style: TextStyle(color: appColors.redColor),
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
