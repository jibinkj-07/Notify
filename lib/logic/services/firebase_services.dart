import 'dart:convert';
import 'dart:developer' as dlog;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotify/logic/cubit/cloud_sync_cubit.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:mynotify/presentation/widgets/auth/auth_form.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../models/event_list_model.dart';
import '../cubit/event_file_handler_cubit.dart';
import 'notification_service.dart';

class FirebaseServices {
  final database = FirebaseFirestore.instance.collection('AllUserEvents');

  //function to upload user event list into cloud
  Future<void> uploadFileToCloud(
      {required List<dynamic> userEventsFile}) async {
    final userJsonData = jsonEncode(userEventsFile);
    String userId;
    try {
      userId = FirebaseAuth.instance.currentUser!.uid;
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
        parentContext.read<CloudSyncCubit>().cloudHasData();
      } catch (error) {
        dlog.log('Error in checkCloudHasFile ${error.toString()}');
        parentContext.read<CloudSyncCubit>().cloudHasNoData();
      }
    });
  }

//updating synctime
  void updateSyncTime() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    database.doc(userId).set({
      'syncTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  //syncinf cloud events function
  void syncCloudEvents({
    required BuildContext parentContext,
    required bool fileExist,
    String? filePath,
  }) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
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
          DateTime time = DateTime.fromMillisecondsSinceEpoch(data['dateTime']);
          String notiBody;
          if (eventType == 'Others') {
            notiBody =
                'You have one event which is going to happen in 5 minutes';
          } else {
            notiBody =
                'You have one $eventType which is going to happen in 5 minutes';
          }
          //setting notification
          NotificationService().showNotification(
              id: notiID,
              title: title,
              body: notiBody,
              eventType: eventType,
              dateTime: time);
          //file is already exist
          if (fileExist) {
            //adding events to device
            Provider.of<EventDataServices>(parentContext, listen: false)
                .addNewEvent(
              id: id,
              notificationId: notiID,
              title: title,
              notes: notes,
              dateTime: time,
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
                dateTime: time,
                eventType: eventType,
                notificationId: notiID,
                eventDate: time.toString(),
              );
              List<EventListModel> newData = [content];
              getApplicationDocumentsDirectory().then((dir) {
                fPath = '${dir.path}/userEvents';
                File fileName = File(fPath);
                fileName.createSync();
                fileName.writeAsStringSync(jsonEncode(newData));
                FirebaseServices().updateSyncTime();
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
                  dateTime: time,
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
          Navigator.of(parentContext)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        });
      } catch (error) {
        dlog.log('Error in syncCloudEvents ${error.toString()}');
      }
    });
  }
}
