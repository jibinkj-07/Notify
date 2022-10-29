import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notify/constants/app_colors.dart';
import 'package:notify/logic/cubit/authentication_cubit.dart';
import 'package:notify/logic/cubit/cloud_sync_cubit.dart';
import 'package:notify/logic/cubit/event_file_handler_cubit.dart';
import 'package:notify/logic/services/firebase_services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserCloudEventSync extends StatefulWidget {
  final String gender;
  const UserCloudEventSync({
    Key? key,
    required this.gender,
  }) : super(key: key);

  @override
  State<UserCloudEventSync> createState() => _UserCloudEventSyncState();
}

class _UserCloudEventSyncState extends State<UserCloudEventSync> {
  FirebaseServices db = FirebaseServices();
  bool _isLoaded = false;
  bool _isSyncing = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _isLoaded = true;
      });
    });
    //calling db function to check cloud events
    Future.delayed(Duration.zero).then((value) {
      db.checkCloudEvents(parentContext: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    FirebaseServices db = FirebaseServices();
    AppColors appColors = AppColors();

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SafeArea(
          child: Container(
            width: screen.width,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //column for image and heading
                Column(
                  children: [
                    //illustration image for sign up
                    SvgPicture.asset(
                      'assets/images/illustrations/cloud_sync.svg',
                      height: screen.height * .4,
                    ),
                    //Heading
                    Container(
                      width: screen.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        "Sync Cloud Events",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //checking user cloud event status
                Expanded(
                  child: _isLoaded
                      ? NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowIndicator();
                            return true;
                          },
                          child: SingleChildScrollView(
                            child: BlocBuilder<CloudSyncCubit, CloudSyncState>(
                                builder: (ctx, state) {
                              if (state.hasData) {
                                //displaying syncing options
                                return Column(
                                  children: [
                                    const Text(
                                      'You have unsynced events in cloud.Do you wish to sync it?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),
                                    _isSyncing
                                        ? Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Syncing Cloud Events',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        appColors.primaryColor,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: LinearPercentIndicator(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    animation: true,
                                                    lineHeight: 8.0,
                                                    animationDuration: 4800,
                                                    percent: 1,
                                                    barRadius:
                                                        const Radius.circular(
                                                            20),
                                                    curve: Curves.slowMiddle,
                                                    progressColor: AppColors()
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              //sync now button
                                              BlocBuilder<EventFileHandlerCubit,
                                                  EventFileHandlerState>(
                                                builder: (ctx, state) {
                                                  return ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isSyncing = true;
                                                      });
                                                      db.syncCloudEventsFromCloud(
                                                        parentContext: context,
                                                        fileExist:
                                                            state.isFileExists,
                                                        gender: widget.gender,
                                                        filePath:
                                                            state.filePath,
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: appColors
                                                          .primaryColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 100),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Sync now",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),

                                              //Horizontal line
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 20.0,
                                                            right: 15.0),
                                                        child: const Divider(
                                                          color: Colors.black,
                                                          height: 30,
                                                        )),
                                                  ),
                                                  const Text("or"),
                                                  Expanded(
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 15.0,
                                                            right: 20.0),
                                                        child: const Divider(
                                                          color: Colors.black,
                                                          height: 30,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              //login button
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/home',
                                                          (Route route) =>
                                                              false);
                                                  context
                                                      .read<
                                                          AuthenticationCubit>()
                                                      .loggingWithCloud(
                                                          gender:
                                                              widget.gender);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(.3),
                                                  foregroundColor:
                                                      Colors.black87,
                                                  elevation: 0,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Go to Home",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    const Text(
                                      "Cloud events not found.",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigator.of(ctx).pop();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil('/home',
                                                (Route route) => false);
                                        context
                                            .read<AuthenticationCubit>()
                                            .loggingWithCloud(
                                                gender: widget.gender);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.grey.withOpacity(.3),
                                        foregroundColor: Colors.black87,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Go to Home",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: appColors.primaryColor,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Checking for cloud events',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
