import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mynotify/logic/database/authentication_helper.dart';
import 'package:mynotify/logic/services/firebase_services.dart';

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
  bool _isLogin = false;
  bool _isObscure = true;
  String _email = '';
  String _password = '';

  //submit function
  void _submitForm({required bool signUp}) {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState!.validate();
    if (valid) {
      _formKey.currentState!.save();

      if (signUp) {
        AuthenticationHelper(parentContext: context)
            .signUp(email: _email, password: _password);
      } else {
        AuthenticationHelper(parentContext: context)
            .signIn(email: _email, password: _password);
      }
    }
  }

  //main part
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        // decoration: BoxDecoration(color: Colors.black.withOpacity(.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: AppColors().primaryColor,
              foregroundColor: Colors.white,
              child: const Icon(
                Iconsax.user,
                size: 50,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
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
              },
              onSaved: (value) {
                _email = value.toString().trim();
              },
              style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              //decoration
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: 'Enter email',
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors().primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors().primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
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
                  color: Colors.black,
                  fontWeight: FontWeight.w500),

              //decoration
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Iconsax.eye4 : Iconsax.eye_slash5,
                    color: AppColors().primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  splashColor: AppColors().primaryColor.withOpacity(.7),
                  splashRadius: 20,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: 'Enter password',
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors().primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors().primaryColor,
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
                          ? ElevatedButton(
                              onPressed: () {
                                _submitForm(signUp: false);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors().primaryColor,
                                onPrimary: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 90, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
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
                          : ElevatedButton(
                              onPressed: () {
                                _submitForm(signUp: true);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors().primaryColor,
                                onPrimary: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 90, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
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
                      _isLogin
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                "Create a new account?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors().primaryColor),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                "Already have an account?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors().primaryColor),
                              ),
                            ),
                    ],
                  );
                } else {
                  return const Text(
                    "Enable mobile data or WiFi for connecting",
                    style: TextStyle(color: Colors.black),
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
