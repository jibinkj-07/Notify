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

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screen.width,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              //column for title and icon
              Text(
                'Sync Your Events',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors().primaryColor),
              ),
              SvgPicture.asset(
                'assets/images/icon.svg',
                width: 180,
                height: 180,
              ),
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
                              'You have unsynced events in cloud. Do you wish to backup all those events?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                          fileExist: state.isFileExists,
                                          filePath: state.filePath,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors().primaryColor,
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                    return _isSyncing
                                        ? Center(
                                            child: Row(
                                              children: [
                                                CircularProgressIndicator(
                                                  color:
                                                      AppColors().primaryColor,
                                                  strokeWidth: 1.5,
                                                ),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  'Syncing Cloud Events',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              db.syncCloudEvents(
                                                parentContext: context,
                                                fileExist: state.isFileExists,
                                              );
                                              setState(() {
                                                _isSyncing = true;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColors().primaryColor,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/home', (Route route) => false);
                                    context
                                        .read<CloudSyncCubit>()
                                        .cloudDataSynced();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey.withOpacity(.3),
                                    onPrimary: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
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
                      //user is synced already
                      else if (state.isSynced) {
                        return Column(
                          children: [
                            const Text(
                              'You have already synced cloud events.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/home', (Route route) => false);
                                context
                                    .read<CloudSyncCubit>()
                                    .cloudDataSynced();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors().primaryColor,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'Go Home',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      }
                      //loading section
                      else {
                        return _isLoaded
                            ? Column(
                                children: [
                                  const Text(
                                    "No cloud events found",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/home', (Route route) => false);
                                      context
                                          .read<CloudSyncCubit>()
                                          .cloudDataSynced();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors().primaryColor,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: AppColors().primaryColor,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Checking for cloud events',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              );
                      }
                    },
                  );
                } else {
                  return const Text(
                    "Please enable WiFi/Mobile data for syncing",
                    style: TextStyle(fontSize: 16),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
