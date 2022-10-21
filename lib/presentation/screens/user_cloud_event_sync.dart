import 'dart:developer';

import 'package:flutter/cupertino.dart';
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
                                const SizedBox(height: 20),
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
                                    : Column(
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
                                                  backgroundColor: Colors.white,
                                                  foregroundColor:
                                                      appColors.primaryColor,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
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
                                                  backgroundColor: Colors.white,
                                                  foregroundColor:
                                                      appColors.primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
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
                                          TextButton(
                                            onPressed: () {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return CupertinoActionSheet(
                                                      title: const Text(
                                                        "Ignoring sync may cause deletion of your backed up data permanantly",
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      actions: [
                                                        CupertinoActionSheetAction(
                                                          child: Text(
                                                            'Ignore',
                                                            style: TextStyle(
                                                              color: appColors
                                                                  .redColor,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(ctx)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamedAndRemoveUntil(
                                                                    '/home',
                                                                    (Route route) =>
                                                                        false);
                                                            context
                                                                .read<
                                                                    CloudSyncCubit>()
                                                                .cloudDataSynced();
                                                          },
                                                        )
                                                      ],
                                                      cancelButton:
                                                          CupertinoActionSheetAction(
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(ctx);
                                                        },
                                                      ),
                                                    );
                                                  });
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              'Ignore Sync',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
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
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              appColors.primaryColor,
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
