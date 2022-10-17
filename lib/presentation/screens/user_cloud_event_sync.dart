import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/cubit/cloud_sync_cubit.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
import 'package:mynotify/logic/cubit/internet_cubit.dart';
import 'package:mynotify/logic/services/firebase_services.dart';

class UserCloudEventSync extends StatefulWidget {
  const UserCloudEventSync({
    Key? key,
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
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        _isLoaded = true;
      });
    });
    //calling db function to check cloud events
    Future.delayed(Duration.zero).then((value) {
      db.checkCloudHasFile(parentContext: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    FirebaseServices db = FirebaseServices();
    AppColors appColors = AppColors();

    return Scaffold(
      backgroundColor: appColors.primaryColor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: screen.width,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  //column for title and icon
                  const Text(
                    'Sync Your Events',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 80),
                  CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.white.withOpacity(.2),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white.withOpacity(.5),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: SvgPicture.asset(
                          'assets/images/icon.svg',
                          width: 140,
                          height: 140,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  //column for sync
                  BlocBuilder<InternetCubit, InternetState>(
                      builder: (internetCtx, internetState) {
                    if (internetState is InternetEnabled) {
                      return BlocBuilder<CloudSyncCubit, CloudSyncState>(
                        builder: (ctx, state) {
                          //user have cloud events
                          if (state.hasData && !state.isSynced) {
                            return Column(
                              children: [
                                const Text(
                                  'You have unsynced events in cloud. Do you wish to backup this events?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                _isSyncing
                                    ? Center(
                                        child: Column(
                                          children: const [
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 1.5,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Syncing Cloud Events',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //sync now button
                                          BlocBuilder<EventFileHandlerCubit,
                                                  EventFileHandlerState>(
                                              builder: (ctx, state) {
                                            if (state.isFileExists) {
                                              return ElevatedButton(
                                                onPressed: () {
                                                  db.syncCloudEvents(
                                                    parentContext: context,
                                                    fileExist:
                                                        state.isFileExists,
                                                    filePath: state.filePath,
                                                  );
                                                  setState(() {
                                                    _isSyncing = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary:
                                                      appColors.primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Sync Now',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            } else
                                            //file not created in device
                                            {
                                              return ElevatedButton(
                                                onPressed: () {
                                                  db.syncCloudEvents(
                                                    parentContext: context,
                                                    fileExist:
                                                        state.isFileExists,
                                                  );
                                                  setState(() {
                                                    _isSyncing = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary:
                                                      appColors.primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Sync Now',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              );
                                            }
                                          }),
                                          const SizedBox(width: 10),
                                          //cancel button
                                          ElevatedButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  //elevates modal bottom screen
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  // gives rounded corner to modal bottom screen

                                                  builder: (ctx) {
                                                    // return SizedBox(
                                                    //   height: screen.width * .4,
                                                    //   child: Padding(
                                                    //     padding:
                                                    //         const EdgeInsets
                                                    //                 .symmetric(
                                                    //             horizontal: 15,
                                                    //             vertical: 10),
                                                    //     child: Column(
                                                    //       mainAxisAlignment:
                                                    //           MainAxisAlignment
                                                    //               .spaceAround,
                                                    //       crossAxisAlignment:
                                                    //           CrossAxisAlignment
                                                    //               .center,
                                                    //       children: [
                                                    //         const Text(
                                                    //           "Ignoring sync may cause deletion of all your backed up cloud events",
                                                    //           style: TextStyle(
                                                    //             fontSize: 16,
                                                    //           ),
                                                    //           textAlign:
                                                    //               TextAlign
                                                    //                   .center,
                                                    //         ),
                                                    //         Row(
                                                    //           mainAxisAlignment:
                                                    //               MainAxisAlignment
                                                    //                   .spaceAround,
                                                    //           children: [
                                                    //             TextButton(
                                                    //               onPressed:
                                                    //                   () {
                                                    //                 Navigator.of(
                                                    //                         ctx)
                                                    //                     .pop();
                                                    //                 Navigator.of(context).pushNamedAndRemoveUntil(
                                                    //                     '/home',
                                                    //                     (Route route) =>
                                                    //                         false);
                                                    //                 context
                                                    //                     .read<
                                                    //                         CloudSyncCubit>()
                                                    //                     .cloudDataSynced();
                                                    //               },
                                                    //               style: TextButton
                                                    //                   .styleFrom(
                                                    //                 primary:
                                                    //                     appColors
                                                    //                         .redColor,
                                                    //                 shape:
                                                    //                     RoundedRectangleBorder(
                                                    //                   borderRadius:
                                                    //                       BorderRadius.circular(
                                                    //                           20),
                                                    //                 ),
                                                    //               ),
                                                    //               child:
                                                    //                   const Text(
                                                    //                 "Ignore",
                                                    //                 style:
                                                    //                     TextStyle(
                                                    //                   fontSize:
                                                    //                       16,
                                                    //                   fontWeight:
                                                    //                       FontWeight
                                                    //                           .bold,
                                                    //                 ),
                                                    //               ),
                                                    //             ),
                                                    //             TextButton(
                                                    //               onPressed:
                                                    //                   () {
                                                    //                 Navigator.of(
                                                    //                         ctx)
                                                    //                     .pop();
                                                    //               },
                                                    //               style: TextButton
                                                    //                   .styleFrom(
                                                    //                 primary:
                                                    //                     appColors
                                                    //                         .primaryColor,
                                                    //                 shape:
                                                    //                     RoundedRectangleBorder(
                                                    //                   borderRadius:
                                                    //                       BorderRadius.circular(
                                                    //                           20),
                                                    //                 ),
                                                    //               ),
                                                    //               child:
                                                    //                   const Text(
                                                    //                 "Cancel",
                                                    //                 style:
                                                    //                     TextStyle(
                                                    //                   fontSize:
                                                    //                       16,
                                                    //                   fontWeight:
                                                    //                       FontWeight
                                                    //                           .bold,
                                                    //                 ),
                                                    //               ),
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // );

                                                    return Container(
                                                      width: screen.width,
                                                      height:
                                                          screen.height * .22,
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          //DELETE BUTTON
                                                          Container(
                                                            height:
                                                                screen.height *
                                                                    .14,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                const Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                8),
                                                                    child: Text(
                                                                      'Ignoring sync may cause deletion of all your backed up cloud events',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black87),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Divider(
                                                                    height: 0,
                                                                    thickness:
                                                                        1),
                                                                SizedBox(
                                                                  height: screen
                                                                          .height *
                                                                      .065,
                                                                  width: screen
                                                                      .width,
                                                                  child: BlocBuilder<
                                                                      EventFileHandlerCubit,
                                                                      EventFileHandlerState>(
                                                                    builder: (ctx1,
                                                                        state) {
                                                                      return ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(ctx)
                                                                              .pop();
                                                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                                                              '/home',
                                                                              (Route route) => false);
                                                                          context
                                                                              .read<CloudSyncCubit>()
                                                                              .cloudDataSynced();
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.white,
                                                                          onPrimary:
                                                                              AppColors().redColor,
                                                                          elevation:
                                                                              0,
                                                                          shape:
                                                                              const RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              bottomLeft: Radius.circular(15),
                                                                              bottomRight: Radius.circular(15),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Ignore",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors().redColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          //CANCEL BUTTON
                                                          SizedBox(
                                                            height:
                                                                screen.height *
                                                                    .065,
                                                            width: screen.width,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        .9),
                                                                onPrimary: AppColors()
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        .3),
                                                                elevation: 0,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                "Cancel",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColors()
                                                                      .primaryColor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Colors.white.withOpacity(.5),
                                              onPrimary: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              'Ignore Sync',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            );
                          }
                          //loading section
                          else {
                            return _isLoaded
                                ? Column(
                                    children: [
                                      const Text(
                                        "Backup cloud events not found.",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil('/home',
                                                  (Route route) => false);
                                          context
                                              .read<CloudSyncCubit>()
                                              .cloudDataSynced();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: appColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: const Text(
                                          'Go Home',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: const [
                                      CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Checking for cloud events',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  );
                          }
                        },
                      );
                    } else {
                      return Text(
                        "Please enable WiFi/Mobile data for syncing",
                        style:
                            TextStyle(fontSize: 16, color: appColors.redColor),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
