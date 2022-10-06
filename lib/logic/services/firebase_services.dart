import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final database = FirebaseFirestore.instance.collection('AllUserEvents');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  //function to upload user event list into cloud
  Future<void> uploadFileToCloud(
      {required List<dynamic> userEventsFile}) async {
    final userJsonData = jsonEncode(userEventsFile);
    await database.doc(userId).set({
      "allEvents": userJsonData,
      'syncTime': DateTime.now(),
    });
  }

  //retrieving cloud data into device
  Future<void> getFileFromCloud() async {
    Map<String, dynamic> allEvents;
    database.doc(userId).get().then((value) {
      final datas = value.data();
      try {
        allEvents = datas!['allEvents'];
        return allEvents;
      } catch (error) {
        print('No data from cloud ${error.toString()}');
        return false;
      }
      // log('Data from cloud are $events');
    });
  }
}
