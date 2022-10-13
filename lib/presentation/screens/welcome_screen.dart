import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/presentation/screens/authentication_screen.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/icon.svg',
                    height: 150,
                    width: 150,
                  ),
                  const Text(
                    'Keep your favourite moments with My Notify',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Sync your data with cloud so you can access anywhere anytime.',
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          reverseDuration: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 300),
                          type: PageTransitionType.fade,
                          child: const AuthenticationScreen(),
                        ),
                      );
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
                      'Connect Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthenticationCubit>().loggingWithoutCloud();
                    },
                    child: Text(
                      "Skip for now",
                      style: TextStyle(
                          fontSize: 16, color: AppColors().primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
