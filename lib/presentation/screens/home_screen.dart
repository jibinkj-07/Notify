import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/logic/cubit/date_cubit.dart';
import 'package:mynotify/presentation/screens/add_event_screen.dart';
import 'package:mynotify/presentation/screens/user_profile_screen.dart';
import 'package:mynotify/presentation/widgets/homescreen/event_list_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

//main
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<DateCubit, DateState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          IconButton(
                            onPressed: state.day == 'Yesterday'
                                ? null
                                : () {
                                    context.read<DateCubit>().prevDay();
                                  },
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: state.day == 'Yesterday'
                                  ? Colors.transparent
                                  : AppColors().primaryColor,
                            ),
                            splashRadius: 20,
                          ),
                          Text(
                            state.day,
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w900),
                          ),
                          IconButton(
                            onPressed: state.day == 'Tomorrow'
                                ? null
                                : () {
                                    context.read<DateCubit>().nextDay();
                                  },
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: state.day == 'Tomorrow'
                                  ? Colors.transparent
                                  : AppColors().primaryColor,
                            ),
                            splashRadius: 20,
                          ),
                        ],
                      );
                    },
                  ),
                  //right part

                  //bloc listener for rendering connect now button

                  BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                      if (!state.isCloudConnected) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/auth');
                          },
                          child: const Text(
                            'Connect Now',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      //profile button
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors().primaryColor,
                        foregroundColor: Colors.white,
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
                        ),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<DateCubit, DateState>(
                    builder: (context, state) {
                      return Text(
                        DateFormat.MMMMEEEEd().format(state.dateTime),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors().primaryColor),
                      );
                    },
                  ),

                  //bloc builder for rendering cloud icon
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                      if (state.isCloudConnected) {
                        return Icon(
                          // Iconsax.cloud,
                          // color: AppColors().primaryColor,
                          Iconsax.cloud_cross,
                          color: AppColors().redColor,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                // child: Center(
                //     child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Icon(
                //       Iconsax.note_text,
                //       color: AppColors().primaryColor,
                //       size: 50,
                //     ),
                //     Text(
                //       "No Events",
                //       style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.w700,
                //           color: AppColors().primaryColor),
                //     )
                //   ],
                // )),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return const EventListItem();
                      },
                      itemCount: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
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
        style: ElevatedButton.styleFrom(
          primary: AppColors().primaryColor,
          onPrimary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Add Event',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
