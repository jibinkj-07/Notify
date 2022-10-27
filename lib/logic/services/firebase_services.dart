import 'dart:convert';
import 'dart:developer' as dlog;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotify/logic/cubit/authentication_cubit.dart';
import 'package:mynotify/logic/cubit/cloud_sync_cubit.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../models/event_list_model.dart';
import '../cubit/event_file_handler_cubit.dart';
import 'notification_service.dart';

class FirebaseServices {
  final database = FirebaseFirestore.instance.collection('AllUserEvents');

//function to create db instance
  Future<void> createProfile({
    required String username,
    required String userId,
    required String email,
    required String gender,
  }) async {
    await database.doc(userId.trim().toString()).set({
      'username': username,
      'email': email,
      'gender': gender,
    }, SetOptions(merge: true));
  }

  //read all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await database.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs
        .map((data) => {
              'userId': data.id,
              'username': data.get('username'),
              'email': data.get('email'),
              'gender': data.get('gender'),
            })
        .toList();
    return allData;
    // return allData;
  }

  //sharing calendar events
  Future<void> shareCalendarEvent(
      {required List<dynamic> userEvents,
      required String senderId,
      required String senderName,
      required String sharingOption,
      required receiverId}) async {
    final time = Timestamp.now();
    await database
        .doc(receiverId.trim().toString())
        .collection('SharedCalendar')
        .doc(senderId.trim().toString())
        .collection('SharedEvents')
        .doc()
        .set({
      'allEvents': jsonEncode(userEvents),
      'name': senderName,
      'sharingOption': sharingOption,
      'mode': 'Received',
      'time': time,
    }, SetOptions(merge: true));
    database
        .doc(receiverId.trim().toString())
        .collection('SharedCalendar')
        .doc(senderId.trim().toString())
        .set({
      'time': time,
      'read': false,
    }, SetOptions(merge: true));
    //current user id end
    await database
        .doc(senderId.trim().toString())
        .collection('SharedCalendar')
        .doc(receiverId.trim().toString())
        .collection('SharedEvents')
        .doc()
        .set({
      'allEvents': jsonEncode(userEvents),
      'name': senderName,
      'sharingOption': sharingOption,
      'mode': 'Sent',
      'time': time,
    }, SetOptions(merge: true));

    database
        .doc(senderId.trim().toString())
        .collection('SharedCalendar')
        .doc(receiverId.trim().toString())
        .set({
      'time': time,
      'read': true,
    }, SetOptions(merge: true));
  }

  //function to upload user event list into cloud
  Future<void> uploadFileToCloud(
      {required List<dynamic> userEventsFile}) async {
    final userJsonData = jsonEncode(userEventsFile);
    String userId;
    try {
      userId = FirebaseAuth.instance.currentUser!.uid.trim().toString();
    } catch (e) {
      return;
    }
    await database.doc(userId).set({
      "allEvents": userJsonData,
      'createdTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  //checking cloud data into device
  void checkCloudHasFile({required BuildContext parentContext}) {
    final userId = FirebaseAuth.instance.currentUser!.uid.trim().toString();
    List<dynamic> allEvents = [];
    database.doc(userId).get().then((value) {
      final datas = value.data();
      try {
        allEvents = jsonDecode(datas!['allEvents']);
        if (allEvents.toString().length < 3) {
          parentContext.read<CloudSyncCubit>().cloudHasNoData();
          return;
        }
        parentContext.read<CloudSyncCubit>().cloudHasData();
      } catch (error) {
        dlog.log('Error in checkCloudHasFile ${error.toString()}');
        parentContext.read<CloudSyncCubit>().cloudHasNoData();
      }
    });
  }

  //clearing sharedCalendar views
  Future<void> clearAllSharedCalendarViews(
      {required String currentUserId, required String targetUserId}) async {
    // await database
    //     .doc(currentUserId)
    //     .collection('SharedCalendar')
    //     .doc(targetUserId)
    //     .collection('SharedEvents').

    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance
        .collection('AllUserEvents')
        .doc(currentUserId)
        .collection('SharedCalendar')
        .doc(targetUserId)
        .collection('SharedEvents');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> deleteSharedCalendarView({
    required String currentUserId,
    required String targetUserId,
    required String id,
  }) async {
    await database
        .doc(currentUserId)
        .collection('SharedCalendar')
        .doc(targetUserId)
        .collection('SharedEvents')
        .doc(id)
        .delete();

    // final instance = FirebaseFirestore.instance;
    // final batch = instance.batch();
    // var collection = instance
    //     .collection('AllUserEvents')
    //     .doc(currentUserId)
    //     .collection('SharedCalendar')
    //     .doc(targetUserId)
    //     .collection('SharedEvents');
    // var snapshots = await collection.get();
    // for (var doc in snapshots.docs) {
    //   batch.delete(doc.reference);
    // }
    // await batch.commit();
  }

  //deleting chat user
  Future<void> deleteChatUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    await database
        .doc(currentUserId)
        .collection('SharedCalendar')
        .doc(targetUserId)
        .delete();
  }

//updating synctime
  void updateSyncTime() {
    final userId = FirebaseAuth.instance.currentUser!.uid.trim().toString();
    database.doc(userId).set({
      'syncTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  //syncinf cloud events function
  void syncCloudEvents({
    required BuildContext parentContext,
    required bool fileExist,
    required String gender,
    String? filePath,
  }) {
    final userId = FirebaseAuth.instance.currentUser!.uid.trim().toString();
    int flag = 0;
    String fPath = '';
    List<dynamic> allEvents = [];
    database.doc(userId).get().then((value) {
      final datas = value.data();
      try {
        allEvents = jsonDecode(datas!['allEvents']);
        //looping between all cloud events
        for (var event in allEvents) {
          final data = jsonDecode(event);
          final id = data['id'];
          final notiID = data['notificationId'];
          final title = data['title'];
          final notes = data['notes'];
          final eventType = data['eventType'];
          DateTime startTime =
              DateTime.fromMillisecondsSinceEpoch(data['startTime']);
          DateTime endTime =
              DateTime.fromMillisecondsSinceEpoch(data['endTime']);
          String notiBody =
              'Event of type $eventType in 5 minutes.Check it out';

          //setting notification
          NotificationService().showNotification(
              id: notiID, title: title, body: notiBody, dateTime: startTime);
          //file is already exist
          if (fileExist) {
            //adding events to device
            Provider.of<EventDataServices>(parentContext, listen: false)
                .addNewEvent(
              id: id,
              notificationId: notiID,
              title: title,
              notes: notes,
              startTime: startTime,
              endTime: endTime,
              eventType: eventType,
              fileExists: true,
              filePath: filePath,
              parentContext: parentContext,
              isSyncing: true,
            );
          } else {
            //creating file if it was first event
            if (flag == 0) {
              EventListModel content = EventListModel(
                id: id.toString(),
                title: title,
                notes: notes,
                startTime: startTime,
                endTime: endTime,
                eventType: eventType,
                notificationId: notiID,
                eventDate: startTime.toString(),
              );
              List<EventListModel> newData = [content];
              getApplicationDocumentsDirectory().then((dir) {
                fPath = '${dir.path}/userEvents';
                File fileName = File(fPath);
                fileName.createSync();
                fileName.writeAsStringSync(jsonEncode(newData));

                //updating the cubit
                parentContext
                    .read<EventFileHandlerCubit>()
                    .fileExists(filePath: fPath);
              });
            } else {
              getApplicationDocumentsDirectory().then((dir) {
                final fiPath = '${dir.path}/userEvents';
                //adding events to device
                Provider.of<EventDataServices>(parentContext, listen: false)
                    .addNewEvent(
                  id: id,
                  notificationId: notiID,
                  title: title,
                  notes: notes,
                  startTime: startTime,
                  endTime: endTime,
                  eventType: eventType,
                  fileExists: true,
                  filePath: fiPath,
                  parentContext: parentContext,
                  isSyncing: true,
                );
              });
            } //end of else
          } //end of for
          flag++;
        }
        Future.delayed(const Duration(seconds: 2), () {
          parentContext.read<CloudSyncCubit>().cloudDataSynced();
          parentContext
              .read<AuthenticationCubit>()
              .loggingWithCloud(gender: gender);
          Navigator.of(parentContext)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        });
      } catch (error) {
        dlog.log('Error in syncCloudEvents ${error.toString()}');
      }
    });
    FirebaseServices().updateSyncTime();
  }
}
