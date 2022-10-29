import 'dart:convert';
import 'dart:developer' as dlog;
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:notify/logic/cubit/authentication_cubit.dart';
import 'package:notify/logic/cubit/cloud_sync_cubit.dart';
import 'package:notify/logic/services/event_data_services.dart';
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
      required String sharedViewDate,
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
      'sharedViewDate': sharedViewDate,
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
      'sharedViewDate': sharedViewDate,
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
  Future<void> uploadEventToCloud({
    required String id,
    required int notificationId,
    required String title,
    required String notes,
    required int startTime,
    required int endTime,
    required String eventDate,
    required String eventType,
  }) async {
    String currentUserId;
    try {
      currentUserId = FirebaseAuth.instance.currentUser!.uid.trim().toString();
    } catch (e) {
      return;
    }
    //adding events into firebase cloud
    await database
        .doc(currentUserId)
        .collection('CloudEvents')
        .doc(notificationId.toString())
        .set({
      'id': id,
      'title': title,
      'notes': notes,
      'startTime': startTime,
      'endTime': endTime,
      'eventDate': eventDate,
      'eventType': eventType,
      'time': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  //function to delete event from firebase cloud
  Future<void> deleteEventFromCloud({required String notificationId}) async {
    final String currentUserId;
    try {
      currentUserId = FirebaseAuth.instance.currentUser!.uid.trim().toString();
      await database
          .doc(currentUserId)
          .collection('CloudEvents')
          .doc(notificationId)
          .delete();
    } catch (e) {
      log('error from firebase service while deleting event ${e.toString()}');
      return;
    }
  }

  //checking cloud data into device
  void checkCloudEvents({
    required BuildContext parentContext,
  }) {
    final currentUserId =
        FirebaseAuth.instance.currentUser!.uid.trim().toString();
    database.doc(currentUserId).collection('CloudEvents').get().then((value) {
      if (value.docs.isNotEmpty) {
        parentContext.read<CloudSyncCubit>().cloudHasData();
      } else {
        parentContext.read<CloudSyncCubit>().cloudHasNoData();
      }
    });
  }

  //clearing sharedCalendar views
  Future<void> clearAllSharedCalendarViews(
      {required String currentUserId, required String targetUserId}) async {
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
  Future<void> syncCloudEventsFromCloud(
      {required BuildContext parentContext,
      required bool fileExist,
      required String filePath,
      required String gender}) async {
    final currentUserId =
        FirebaseAuth.instance.currentUser!.uid.trim().toString();
    int flag = 0;
    String fPath = '';
    await database
        .doc(currentUserId)
        .collection('CloudEvents')
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        final event = value.docs[i];
        //getting details from cloud event
        final id = event.get('id');
        final notificationId = int.parse(event.id);
        final title = event.get('title');
        final notes = event.get('notes');
        final startTime =
            DateTime.fromMillisecondsSinceEpoch(event.get('startTime'));
        final endTime =
            DateTime.fromMillisecondsSinceEpoch(event.get('endTime'));
        final eventType = event.get('eventType');

        //checking if  device contain current cloud event
        if (fileExist) {
          log('file exist from fb');
          final deviceEventList =
              EventDataServices().readDataFromFile(filePath: filePath);
          if (deviceEventList.toString().contains(id)) {
            log('Device already have this event $title');
            return;
          } else {
            log('$title added to device file');
            //NOTIFICATION PART
            String notiBody =
                'Event of type $eventType in 5 minutes.Check it out';
            NotificationService().showNotification(
              id: notificationId,
              title: title,
              body: notiBody,
              dateTime: startTime,
            );

            //ADDING CLOUD EVENTS INTO DEVICE FILE
            Provider.of<EventDataServices>(parentContext, listen: false)
                .addNewEvent(
              id: id,
              notificationId: notificationId,
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

            //end of if (deviceEventList.toString().contains(id)) ..else
          }

          //end of if (fileExist)
        } else {
          //creating file if it was first event
          if (flag == 0) {
            log('file created from fb and added $title');
            EventListModel content = EventListModel(
              id: id.toString(),
              title: title,
              notes: notes,
              startTime: startTime,
              endTime: endTime,
              eventType: eventType,
              notificationId: notificationId,
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
            log('file not  exist but created then added from fb and added $title');
            getApplicationDocumentsDirectory().then((dir) {
              final fiPath = '${dir.path}/userEvents';
              //adding events to device
              Provider.of<EventDataServices>(parentContext, listen: false)
                  .addNewEvent(
                id: id,
                notificationId: notificationId,
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
        }
        flag++;
        //end of for (var i = 0; i < value.docs.length; i++)
      }
    });
    FirebaseServices().updateSyncTime();
    //ROUTING USER TO HOMEPAGE
    Future.delayed(const Duration(seconds: 5), () {
      parentContext
          .read<AuthenticationCubit>()
          .loggingWithCloud(gender: gender);
      parentContext.read<CloudSyncCubit>().cloudDataSynced();
      Navigator.of(parentContext)
          .pushNamedAndRemoveUntil('/home', (route) => false);
    });
  }
}
