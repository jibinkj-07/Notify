import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../widgets/auth/auth_form.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    AppColors appColors = AppColors();
    return Scaffold(
      backgroundColor: appColors.primaryColor,
      appBar: AppBar(
        backgroundColor: appColors.primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 20.0,
        ),
        title: const Text(
          'Connect Now',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: AuthForm(
              screen: screen,
              parentContext: context,
            ),
          ),
        ),
      ),
    );
  }
}
