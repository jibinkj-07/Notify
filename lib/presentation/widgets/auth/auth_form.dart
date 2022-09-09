import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../constants/app_colors.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.screen,
  }) : super(key: key);

  final Size screen;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //variables declaration
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = false;
  bool _isObscure = true;

//form submission function
  void submitAuthForm() {
    _formKey.currentState!.validate();
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
              key: const ValueKey('username'),
              textInputAction: TextInputAction.next,

              //validation
              validator: (data) {
                if (data!.isEmpty) {
                  return 'Enter an username';
                } else if (data.length < 4) {
                  return "Username should have atleast 4 letters";
                }
              },
              style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              //decoration
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: 'Enter username',
                labelText: 'Username',
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
            _isLogin
                ? ElevatedButton(
                    onPressed: () {
                      submitAuthForm();
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
                      submitAuthForm();
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
                          fontSize: 16, color: AppColors().primaryColor),
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
                          fontSize: 16, color: AppColors().primaryColor),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
