import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/logic/services/firebase_services.dart';

import '../../../constants/app_colors.dart';

class CalendarMessageSend extends StatefulWidget {
  const CalendarMessageSend(
      {super.key, required this.sharingDateTime, required this.userAllEvents});
  final DateTime? sharingDateTime;
  final List<Map<String, dynamic>> userAllEvents;

  @override
  State<CalendarMessageSend> createState() => _CalendarMessageSendState();
}

class _CalendarMessageSendState extends State<CalendarMessageSend> {
  String shareOption = 'month';
  List<Map<String, dynamic>> allUsersFromDb = [];
  List<Map<String, dynamic>> allUsers = [];
  String query = '';
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    readUsersFromDb();
    super.initState();
    log('all events are ${widget.userAllEvents.toString()}');
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void readUsersFromDb() async {
    final data = await FirebaseServices().getUsers();
    if (!mounted) return;
    setState(() {
      allUsersFromDb = data;
      allUsers = allUsersFromDb;
    });
  }

  //main section
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    final screen = MediaQuery.of(context).size;
    final DateTime dateTime = widget.sharingDateTime as DateTime;
    List<Map<String, dynamic>> sortedUserEvents = [];
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final currentUsername = FirebaseAuth.instance.currentUser!.displayName;
    FirebaseServices firebaseServices = FirebaseServices();

    //choosing user events based on month or day
    if (shareOption == 'month' && widget.userAllEvents.isNotEmpty) {
      sortedUserEvents = widget.userAllEvents.where((element) {
        final dateFromEvents = element['eventDate'].toString();
        final selectedMonth =
            '${widget.sharingDateTime!.year}-${widget.sharingDateTime!.month}';
        return dateFromEvents.contains(selectedMonth);
      }).toList();
      log('sorted events from month are $sortedUserEvents');
    } else if (shareOption == 'day' && widget.userAllEvents.isNotEmpty) {
      sortedUserEvents = widget.userAllEvents.where((element) {
        final dateFromEvents = element['eventDate'].toString();
        final selectedDay =
            '${widget.sharingDateTime!.year}-${widget.sharingDateTime!.month}-${widget.sharingDateTime!.day}';
        return dateFromEvents.contains(selectedDay);
      }).toList();
      log('sorted events from day are $sortedUserEvents');
    }

    String sharingDate;
    if (shareOption == 'month' && widget.sharingDateTime != null) {
      sharingDate = DateFormat.yMMMM().format(dateTime);
    } else {
      sharingDate = DateFormat.yMMMMEEEEd().format(dateTime);
    }
//search function
    void searchUser(String query) {
      final users = allUsersFromDb.where((user) {
        final nameLower = user['username'].toString().toLowerCase();
        final emailLower = user['email'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return nameLower.contains(searchQuery) ||
            emailLower.contains(searchQuery);
      }).toList();
      log('search result $users');
      setState(() {
        this.query = query;
        allUsers = users;
      });
    }

    //main
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: screen.width,
          child: Column(
            children: [
              //COLUMN FOR APPBAR SECTION
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors().primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //COLUMN FOR BODY SECTION
              Expanded(
                child: Column(
                  children: [
                    //COLUMN FOR TOP PART TILL SEARCH BAR
                    Column(
                      children: [
                        //illustration image
                        SvgPicture.asset(
                          'assets/images/illustrations/share.svg',
                          height: 10,
                        ),
                        const SizedBox(height: 5),
                        //heading
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Share Event Calendar',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        //choosing share option
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoSegmentedControl(
                              borderColor: appColors.primaryColor,
                              selectedColor: appColors.primaryColor,
                              children: const {
                                'month': Text(
                                  "Month",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                'day': Text(
                                  "Single day",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              },
                              groupValue: shareOption,
                              onValueChanged: (value) {
                                setState(() {
                                  shareOption = value.toString();
                                });
                              }),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Sharing events of $sharingDate',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appColors.primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //COLUMN FOR BOTTOM PART
                    sortedUserEvents.isNotEmpty
                        ? Expanded(
                            child: Column(
                              children: [
                                //search bar
                                CupertinoSearchTextField(
                                  controller: searchTextController,
                                  placeholder: 'Search',
                                  onChanged: (value) {
                                    searchUser(value.toString());
                                  },
                                ),

                                //list view
                                NotificationListener<
                                    OverscrollIndicatorNotification>(
                                  onNotification: (overscroll) {
                                    overscroll.disallowIndicator();
                                    return true;
                                  },
                                  child: Expanded(
                                    child: allUsersFromDb.isEmpty
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color: appColors.primaryColor,
                                            ),
                                          )
                                        : allUsers.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: allUsers.length,
                                                itemBuilder: (ctx, index) {
                                                  final name = allUsers[index]
                                                      ['username'];
                                                  final userId =
                                                      allUsers[index]['userId'];
                                                  final email =
                                                      allUsers[index]['email'];

                                                  //skipping current logged user
                                                  // if (userId == currentUserId) {
                                                  //   return const SizedBox();
                                                  // }
                                                  return ListTile(
                                                    leading: SvgPicture.asset(
                                                      'assets/images/illustrations/male_avatar.svg',
                                                      height: 45,
                                                    ),
                                                    title: Text(
                                                      name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Text(email),
                                                    trailing: userId !=
                                                            currentUserId
                                                        ? ElevatedButton(
                                                            onPressed: () {
                                                              //sending events
                                                              firebaseServices
                                                                  .shareCalendarEvent(
                                                                userEvents:
                                                                    sortedUserEvents,
                                                                senderId:
                                                                    currentUserId,
                                                                senderName:
                                                                    currentUsername ??
                                                                        'user',
                                                                sharingOption:
                                                                    shareOption,
                                                                receiverId:
                                                                    userId,
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  appColors
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          .2),
                                                              foregroundColor:
                                                                  appColors
                                                                      .primaryColor,
                                                              elevation: 0,
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 0,
                                                                  horizontal:
                                                                      10),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              "Send",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          )
                                                        : null,
                                                  );
                                                },
                                              )
                                            : SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 30),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'No user found with "$query"',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      SvgPicture.asset(
                                                        'assets/images/illustrations/no_userFound.svg',
                                                        height: 120,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/illustrations/no_userFound.svg',
                                  height: 100,
                                ),
                                const Text(
                                  "Events not found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
