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
import 'package:mynotify/presentation/screens/add_event_screen.dart';
import 'package:mynotify/presentation/screens/user_profile_screen.dart';
import 'package:mynotify/presentation/widgets/homescreen/event_list.dart';
import 'package:mynotify/presentation/widgets/homescreen/event_list_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';

import '../../logic/cubit/internet_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

//main
  @override
  Widget build(BuildContext context) {
    //floating button
    var elevatedButton = ElevatedButton(
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
    );

    //main
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                color: AppColors().primaryColor),
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
                          child: Text(
                            'Connect Now',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors().primaryColor),
                          ),
                        );
                      }

                      return Row(
                        children: [
                          //bloc builder for rendering cloud icon
                          BlocBuilder<InternetCubit, InternetState>(
                            builder: (context, state) {
                              if (state is InternetEnabled) {
                                return Icon(
                                  Iconsax.cloud5,
                                  color: AppColors().greenColor,
                                );
                              } else {
                                return Icon(
                                  Iconsax.cloud_cross5,
                                  color: AppColors().redColor,
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          //profile iconbutton
                          CircleAvatar(
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
                          ),
                        ],
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
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<DateCubit, DateState>(
                  builder: (context, state) {
                    return EventList(
                        currentDateTime:
                            DateFormat('yyyy-MM-dd').format(state.dateTime));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: elevatedButton,
    );
  }
}
