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
}
