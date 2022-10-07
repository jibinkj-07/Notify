import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/logic/database/authentication_helper.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:mynotify/logic/services/firebase_services.dart';

import '../../constants/app_colors.dart';
import '../../logic/cubit/cloud_sync_cubit.dart';
import '../../logic/cubit/event_file_handler_cubit.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();
    //saving file from cloud to device
    syncFileFromCloud({required bool fileExist, String? filePath}) {
      firebaseServices.getFileFromCloud(
          parentContext: context, fileExist: fileExist, filePath: filePath);
    }

    //current user
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors().primaryColor,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors().primaryColor,
                foregroundColor: Colors.white,
                child: const Icon(
                  Iconsax.user,
                  size: 50,
                ),
              ),
              const SizedBox(height: 40),

              //cloud sync part
              BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
                builder: (context, fileState) {
                  return BlocBuilder<CloudSyncCubit, CloudSyncState>(
                    builder: (ctx, state) {
                      if (!state.isSynced) {
                        FirebaseServices()
                            .checkCloudHasFile(parentContext: context);
                      }
                      if (!state.isSynced && state.hasData) {
                        log('data not synced');
                        return Column(
                          children: [
                            const Text(
                              "You have events backed up in cloud.",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            fileState.isFileExists
                                ? ElevatedButton(
                                    onPressed: () {
                                      syncFileFromCloud(
                                        fileExist: true,
                                        filePath: fileState.filePath,
                                      );
                                      context
                                          .read<CloudSyncCubit>()
                                          .cloudDataSynced();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors().primaryColor,
                                      onPrimary: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Sync Now",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      syncFileFromCloud(
                                        fileExist: false,
                                      );
                                      context
                                          .read<CloudSyncCubit>()
                                          .cloudDataSynced();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors().primaryColor,
                                      onPrimary: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Sync Now",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            const Divider(thickness: 1),
                            const SizedBox(height: 30),
                          ],
                        );
                      } else {
                        log('data synced');
                        //retrieving syn time from db
                        DateTime time = firebaseServices.getSyncTime();
                        //sync part
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last sync time',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                DateFormat.yMMMMd().add_jm().format(time),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),

              //email part
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userEmail.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  context.read<AuthenticationCubit>().loggingWithoutCloud();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors().redColor,
                  onPrimary: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
