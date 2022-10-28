import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/logic/cubit/internet_cubit.dart';
import 'calendar_message_list.dart';

class CalendarMessageScreen extends StatefulWidget {
  const CalendarMessageScreen({
    super.key,
  });

  @override
  State<CalendarMessageScreen> createState() => _CalendarMessageScreenState();
}

class _CalendarMessageScreenState extends State<CalendarMessageScreen> {
  //main
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    final screen = MediaQuery.of(context).size;

    // log('user id is $currentUserId');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: appColors.primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text(
          'Shared Calendar',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          if (state.isCloudConnected) {
            final currentUserId = FirebaseAuth.instance.currentUser!.uid;
            return BlocBuilder<InternetCubit, InternetState>(
              builder: (context, state) {
                if (state is InternetEnabled) {
                  return CalendarMessageList(
                    currentUserId: currentUserId,
                    appColors: appColors,
                    screen: screen,
                  );
                }
                //no internet
                else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/illustrations/no_internet.svg',
                          height: 200,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Connection lost",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: appColors.redColor),
                        ),
                        const Text(
                          "Please turn on Mobile data or Wifi",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/illustrations/no_userFound.svg',
                    height: 200,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This feature is only available to Notify users",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      //Going to signup page
                      Navigator.of(context).pushNamed('/authentication');
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
                      "Connect now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
