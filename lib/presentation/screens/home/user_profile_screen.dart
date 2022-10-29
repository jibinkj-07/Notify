import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:notify/logic/cubit/authentication_cubit.dart';
import 'package:notify/logic/cubit/cloud_sync_cubit.dart';
import 'package:notify/presentation/screens/onboarding/user_cloud_event_sync.dart';
import '../../../constants/app_colors.dart';

class UserProfileScreen extends StatefulWidget {
  final String gender;
  const UserProfileScreen({Key? key, required this.gender}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isSyncTime = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  DateTime? time;
  void checkSyncTime() {
    FirebaseFirestore.instance
        .collection("AllUserEvents")
        .doc(userId)
        .get()
        .then((snapshot) {
      try {
        log('Data from db is ${snapshot.get('syncTime').toDate()}');
        setState(() {
          isSyncTime = true;
          time = snapshot.get('syncTime').toDate();
        });
      } catch (e) {
        log('error while get sync time');
        if (!mounted) return;
        setState(() {
          isSyncTime = false;
        });
      }
    });
  }

  @override
  void initState() {
    checkSyncTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    //current user
    String userEmail = '';
    String username = '';
    try {
      userEmail = FirebaseAuth.instance.currentUser!.email.toString();
      username = FirebaseAuth.instance.currentUser!.displayName.toString();
    } catch (e) {
      log('error in profile screen ${e.toString()}');
      userEmail = 'notify@notify.com';
      username = 'User';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: appColors.primaryColor,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //user avatar
                      SvgPicture.asset(
                        'assets/images/illustrations/${widget.gender}_avatar.svg',
                        height: 200,
                      ),
                      const SizedBox(height: 20),
                      //user name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 5),
                            child: Material(
                              color: Colors.grey.withOpacity(.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(
                                  username.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      //user email

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 5),
                            child: Material(
                              color: Colors.grey.withOpacity(.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Text(
                                  userEmail.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      //user last sync time
                      if (isSyncTime)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                "Last Sync Time",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 5),
                              child: Material(
                                color: Colors.grey.withOpacity(.2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text(
                                    DateFormat.yMMMd().add_jm().format(time!),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      BlocBuilder<CloudSyncCubit, CloudSyncState>(
                        builder: (context, state) {
                          if (!state.isSynced && state.hasData) {
                            return Column(
                              children: [
                                const Text(
                                  "You have unsynced cloud events",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => UserCloudEventSync(
                                            gender: widget.gender),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 100),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sync now",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  context.read<AuthenticationCubit>().loggingWithoutCloud();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.redColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
