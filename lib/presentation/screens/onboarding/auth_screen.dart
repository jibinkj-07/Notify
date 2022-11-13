import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:page_transition/page_transition.dart';
import '../../../constants/app_colors.dart';
import '../../../logic/cubit/authentication_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    AppColors appColors = AppColors();

    //main section
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //illustration image of auth
              SvgPicture.asset(
                'assets/images/illustrations/auth.svg',
                width: screen.width,
                height: screen.height * .5,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        //Heading
                        Text(
                          "Connect with us",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: appColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        //subtitle
                        const Text(
                          "Connect with Notify and automatically back up your events in cloud",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    //sign up button
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //Going to signup page

                            Navigator.of(context).pushNamed('/signup');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //Horizontal line
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 15.0),
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 30,
                                  )),
                            ),
                            const Text("or"),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 20.0),
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 30,
                                  )),
                            ),
                          ],
                        ),
                        //login button
                        OutlinedButton(
                          onPressed: () {
                            //Going to login page
                            Navigator.of(context).pushNamed('/login');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: appColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(
                                color: appColors.primaryColor, width: 1),
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
                    ),
                    //skip section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not necessary'),
                        InkWell(
                          splashColor: appColors.primaryColor.withOpacity(.5),
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            //Going to homepage by updating cubit state
                            context
                                .read<AuthenticationCubit>()
                                .loggingWithoutCloud();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (route) => false);
                          },
                          child: Ink(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              'Skip for now',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
