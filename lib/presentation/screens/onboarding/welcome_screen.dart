import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Welcome illustrator image
              SvgPicture.asset(
                'assets/images/illustrations/welcome.svg',
                width: screen.width,
                height: screen.height * .5,
              ),
              Column(
                children: [
                  //App name
                  Text(
                    "Welcome to Notify",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: appColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  //subtitle
                  const Text(
                    "Remember your favourite moments with Noftify",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              //button
              ElevatedButton(
                onPressed: () {
                  //Going to loginpage
                  Navigator.of(context).pushNamed('/authentication');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
