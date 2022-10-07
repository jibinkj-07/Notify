import 'dart:convert';
import 'dart:developer' as dlog;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mynotify/logic/cubit/cloud_sync_cubit.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:provider/provider.dart';
import 'notification_service.dart';

class FirebaseServices {
  final database = FirebaseFirestore.instance.collection('AllUserEvents');

  //function to upload user event list into cloud
  Future<void> uploadFileToCloud(
      {required List<dynamic> userEventsFile, required bool merge}) async {
    final userJsonData = jsonEncode(userEventsFile);
    String userId;
    try {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } catch (e) {
      dlog.log('User not signed');
      return;
    }

    await database.doc(userId).set({
      "allEvents": userJsonData,
      'syncTime': Timestamp.now(),
    }, SetOptions(merge: merge));
  }

  //checking cloud data into device
  void checkCloudHasFile({required BuildContext parentContext}) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> allEvents = [];
    database.doc(userId).get().then((value) {
      final datas = value.data();
      try {
        allEvents = jsonDecode(datas!['allEvents']);

        if (allEvents.toString().length < 3) {
          parentContext.read<CloudSyncCubit>().cloudHasNoData();
          return;
        }
        dlog.log('user have cloud data and type is ${allEvents.runtimeType}');
        parentContext.read<CloudSyncCubit>().cloudHasData();
      } catch (error) {
        dlog.log('No data from cloud ${error.toString()}');
        parentContext.read<CloudSyncCubit>().cloudHasNoData();
      }
    });
  }

  //retrieving cloud data into device
  void getFileFromCloud({
    required BuildContext parentContext,
    required bool fileExist,
    String? filePath,
  }) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> allEvents = [];
    database.doc(userId).get().then((value) {
      final datas = value.data();

      try {
        allEvents = jsonDecode(datas!['allEvents']);
        for (var item in allEvents) {
          Map mapData = jsonDecode(item);
          final id = mapData['id'];
          final notificationId = mapData['notificationId'];
          final title = mapData['title'];
          final notes = mapData['notes'];
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(mapData['dateTime']);
          final eventType = mapData['eventType'];

          //calling notification
          String notiBody;
          if (eventType == 'Others') {
            notiBody =
                'You have one event which is going to happen in 5 minutes';
          } else {
            notiBody =
                'You have one $eventType which is going to happen in 5 minutes';
          }
          //notification part
          NotificationService().showNotification(
            id: notificationId,
            title: title,
            body: notiBody,
            dateTime: dateTime,
            eventType: eventType,
          );

          Provider.of<EventDataServices>(parentContext, listen: false)
              .addNewEventFromCloud(
                  id: id,
                  notificationId: notificationId,
                  title: title,
                  notes: notes,
                  dateTime: dateTime,
                  eventType: eventType,
                  fileExists: fileExist,
                  filePath: filePath,
                  parentContext: parentContext);
        }

        // log('user have cloud data and type is ${allEvents.runtimeType}');
        // log('data from service is ${allEvents.toString()}');

        // parentContext.read<CloudSyncCubit>().cloudHasData();
        // log(' cloud sync cubit called');
      } catch (error) {
        dlog.log('No data from cloud ${error.toString()}');
        parentContext.read<CloudSyncCubit>().cloudHasNoData();
      }
    });
  }

  //retrieving syn time from db
  DateTime getSyncTime() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    DateTime time = DateTime.now();
    database.doc(userId).get().then((value) {
      final data = value.data();
      final syncTime = data!['syncTime'];
      time = syncTime.toDate();
      dlog.log('sync time is $time');
    });
    return time;
  }
}
