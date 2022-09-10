import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_colors.dart';
import '../widgets/auth/auth_form.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors().primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // const SizedBox(width: 20),
                  const Text(
                    'Connect Now',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: AuthForm(
                screen: screen,
                parentContext: context,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
