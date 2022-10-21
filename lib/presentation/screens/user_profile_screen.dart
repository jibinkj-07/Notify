import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import '../../constants/app_colors.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

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
    //current user
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    final username = FirebaseAuth.instance.currentUser!.displayName;
    AppColors appColors = AppColors();

    return Scaffold(
      backgroundColor: appColors.primaryColor,
      appBar: AppBar(
        backgroundColor: appColors.primaryColor,
        foregroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              //profile avatar
              CircleAvatar(
                radius: 85,
                backgroundColor: Colors.white.withOpacity(.2),
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.white.withOpacity(.5),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.white,
                    foregroundColor: appColors.primaryColor,
                    child: const Icon(
                      Iconsax.user,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              //username part
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              //email part
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
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
              if (isSyncTime)
                //last sync part
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Synced',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat.yMMMd().add_jm().format(time!),
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
                  primary: appColors.redColor,
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
