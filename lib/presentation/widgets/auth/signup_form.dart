import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../constants/app_colors.dart';
import '../../../logic/cubit/internet_cubit.dart';
import '../../../logic/database/authentication_helper.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool pwObscure = true;
  String _email = '';
  String _password = '';
  String _username = '';
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
      error = await AuthenticationHelper(parentContext: context)
          .signUp(username: _username, email: _email, password: _password);
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
          children: [
            //user name
            TextFormField(
              cursorColor: appColors.primaryColor,
              key: const ValueKey('username'),
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              //validator
              validator: (data) {
                if (data!.isEmpty) {
                  return 'Provide a name';
                }
              },
              onSaved: (value) {
                _username = value.toString().trim();
              },
              style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              //decoration
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Enter Name',
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
            //user email section

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
                hintText: 'Enter email address',
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
            //password section
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
                hintText: 'Enter password',
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
            //signup button

            isLoading
                ? CircularProgressIndicator(
                    color: appColors.primaryColor,
                    strokeWidth: 1.5,
                  )
                : BlocBuilder<InternetCubit, InternetState>(
                    builder: (ctx, state) {
                      if (state is InternetEnabled) {
                        return ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return Text(
                          "Enable mobile data or Wifi to continue",
                          style: TextStyle(
                            color: appColors.redColor,
                            fontWeight: FontWeight.bold,
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
