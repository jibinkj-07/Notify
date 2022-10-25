import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/logic/cubit/date_cubit.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
import 'package:mynotify/presentation/screens/home/add_event_screen.dart';
import 'package:mynotify/presentation/screens/home/calender_screen.dart';
import 'package:mynotify/presentation/screens/home/user_profile_screen.dart';
import 'package:mynotify/presentation/widgets/homescreen/event_list.dart';
import 'package:page_transition/page_transition.dart';
import '../../../logic/cubit/internet_cubit.dart';
import '../../../logic/services/notification_service.dart';

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
      body: SafeArea(
        child: BlocBuilder<DateCubit, DateState>(builder: (context, state) {
          final day = DateFormat.d().format(state.dateTime);
          //checking cloud data
          return SizedBox(
            width: screen.width,
            child: Column(
              children: [
                //appbar section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<InternetCubit, InternetState>(
                        builder: (context, state) {
                          if (state is InternetEnabled) {
                            return CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  AppColors().greenColor.withOpacity(.3),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    AppColors().greenColor.withOpacity(.8),
                                child: const Icon(
                                  Iconsax.cloud5,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  AppColors().redColor.withOpacity(.3),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors().redColor,
                                child: const Icon(
                                  Iconsax.cloud_cross5,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      //right end items
                      Row(
                        children: [
                          //cubit to read file path
                          BlocBuilder<EventFileHandlerCubit,
                              EventFileHandlerState>(
                            builder: (context, state) {
                              return IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      reverseDuration:
                                          const Duration(milliseconds: 300),
                                      duration:
                                          const Duration(milliseconds: 400),
                                      type: PageTransitionType.fade,
                                      child: CalenderScreen(
                                          filePath: state.filePath),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Iconsax.calendar_1,
                                ),
                                color: AppColors().primaryColor,
                                splashRadius: 20.0,
                                iconSize: 25.0,
                              );
                            },
                          ),
                          // const SizedBox(width: 10),
                          //bloc listener for rendering connect now button
                          BlocBuilder<AuthenticationCubit, AuthenticationState>(
                            builder: (context, state) {
                              if (!state.isCloudConnected) {
                                return TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/authentication');
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors()
                                        .primaryColor
                                        .withOpacity(.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Connect',
                                    style: TextStyle(
                                      color: AppColors().primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }

                              return CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/user');
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  child: SvgPicture.asset(
                                    'assets/images/illustrations/profile_avatar.svg',
                                  ),
                                ),
                              );
                            },
                          ),
                          // const SizedBox(width: 10)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                //day in full format
                Container(
                  width: screen.width * .95,
                  height: screen.height * .21,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors().primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 6,
                        blurRadius: 8,
                        offset:
                            const Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //prev button
                      IconButton(
                        onPressed: state.day == 'Yesterday'
                            ? null
                            : () {
                                context.read<DateCubit>().prevDay();
                              },
                        icon: Icon(
                          Iconsax.arrow_circle_left,
                          color: state.day == 'Yesterday'
                              ? Colors.transparent
                              : Colors.white,
                        ),
                        iconSize: 30,
                      ),
                      //Event numbers
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.day,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.EEEE().format(state.dateTime),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
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
                          )
                        ],
                      ),
                      //Date display

                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
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
                      //next button
                      IconButton(
                        onPressed: state.day == 'Tomorrow'
                            ? null
                            : () {
                                context.read<DateCubit>().nextDay();
                              },
                        icon: Icon(
                          Iconsax.arrow_circle_right,
                          color: state.day == 'Tomorrow'
                              ? Colors.transparent
                              : Colors.white,
                        ),
                        iconSize: 30,
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
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              reverseDuration: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 200),
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
