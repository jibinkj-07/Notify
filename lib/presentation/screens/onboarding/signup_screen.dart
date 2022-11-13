import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/auth/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    AppColors appColors = AppColors();

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
                    'assets/images/illustrations/sign_up.svg',
                    height: screen.height * .25,
                  ),
                  const SizedBox(height: 5),
                  //Heading
                  Container(
                    width: screen.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Sign Up",
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
              //column for signup form
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: const SingleChildScrollView(
                    child: SignUpForm(),
                  ),
                ),
              ),
              //column for login section
              Column(
                children: [
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account'),
                      InkWell(
                        splashColor: appColors.primaryColor.withOpacity(.5),
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          //Going to loginpage
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: appColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
