import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';

import 'package:mynotify/logic/cubit/date_cubit.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:mynotify/logic/services/firebase_services.dart';
import 'package:mynotify/presentation/screens/add_event_screen.dart';
import 'package:mynotify/presentation/screens/user_profile_screen.dart';
import 'package:mynotify/presentation/widgets/homescreen/event_list.dart';
import 'package:mynotify/presentation/widgets/homescreen/event_list_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';

import '../../logic/cubit/internet_cubit.dart';
import '../../logic/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    NotificationService().initializePlatformNotifications();
    super.initState();
  }

//main
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors().primaryColor,
        elevation: 0,
        leading: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetEnabled) {
              return const Icon(
                Iconsax.cloud5,
                color: Colors.green,
                size: 24,
              );
            } else {
              return Icon(
                Iconsax.cloud_cross5,
                color: AppColors().redColor,
                size: 24,
              );
            }
          },
        ),
        actions: [
          Row(
            children: [
              //bloc listener for rendering connect now button
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (!state.isCloudConnected) {
                    return TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/auth');
                      },
                      child: Text(
                        'Connect Now',
                        style: TextStyle(
                          color: AppColors().primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return CircleAvatar(
                    radius: 21,
                    backgroundColor: AppColors().primaryColor,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors().primaryColor,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              reverseDuration:
                                  const Duration(milliseconds: 300),
                              duration: const Duration(milliseconds: 300),
                              type: PageTransitionType.rightToLeft,
                              child: const UserProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Iconsax.user,
                        ),
                        iconSize: 20,
                        splashRadius: 25,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10)
            ],
          ),
        ],
      ),
      body: BlocBuilder<DateCubit, DateState>(builder: (context, state) {
        final day = DateFormat.d().format(state.dateTime);
        return Column(
          children: [
            //Day selecting section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screen.width * .9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: state.day == 'Yesterday'
                            ? null
                            : () {
                                context.read<DateCubit>().prevDay();
                              },
                        icon: Icon(
                          Iconsax.arrow_circle_left5,
                          color: state.day == 'Yesterday'
                              ? Colors.transparent
                              : AppColors().primaryColor,
                        ),
                        iconSize: 40,
                        splashRadius: 20,
                      ),
                      Text(
                        state.day,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors().primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: state.day == 'Tomorrow'
                            ? null
                            : () {
                                context.read<DateCubit>().nextDay();
                              },
                        icon: Icon(
                          Iconsax.arrow_circle_right5,
                          color: state.day == 'Tomorrow'
                              ? Colors.transparent
                              : AppColors().primaryColor,
                        ),
                        splashRadius: 20,
                        iconSize: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            //day in full format
            Container(
              width: screen.width * .94,
              height: screen.height * .2,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors().primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 6,
                    blurRadius: 8,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Event numbers
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        DateFormat.EEEE().format(state.dateTime),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      // const Text(
                      //   'Events: 01',
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ),
                  //Date display

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   width: 4,
                          //   color: Colors.white,
                          // ),
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        child: Text(
                          day.length < 2 ? '0$day' : day,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppColors().primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat.yMMMM().format(state.dateTime),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //event listview
            Expanded(
              child: EventList(
                  currentDateTime:
                      DateFormat('yyyy-MM-dd').format(state.dateTime)),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              reverseDuration: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 300),
              type: PageTransitionType.bottomToTop,
              child: const AddEventScreen(),
            ),
          );
        },
        backgroundColor: AppColors().primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(
          Iconsax.note_add5,
          size: 30,
        ),
      ),
    );
  }
}
