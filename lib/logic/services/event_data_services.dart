import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
import 'package:mynotify/logic/services/firebase_services.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/event_list_model.dart';

class EventDataServices with ChangeNotifier {
  FirebaseServices firebaseServices = FirebaseServices();
  List<dynamic> _allEvents = [];

  //Reading data from file
  dynamic readDataFromFile({required String filePath}) {
    File fileName = File(filePath);
    List<dynamic> data = jsonDecode(fileName.readAsStringSync());
    _allEvents = data.toSet().toList();
    _allEvents.sort();

    return _allEvents;
  }

//CREATING FILE
  void createFile(
      {required EventListModel content, required BuildContext parentContext}) {
    List<EventListModel> newData = [content];
    getApplicationDocumentsDirectory().then((dir) {
      final name = '${dir.path}/userEvents';
      File fileName = File(name);
      fileName.createSync();
      fileName.writeAsStringSync(jsonEncode(newData));
      firebaseServices.uploadFileToCloud(userEventsFile: newData, merge: true);
      //updating the cubit
      parentContext.read<EventFileHandlerCubit>().fileExists(filePath: name);
    });
  }

//WRITING DATA INTO FILE
  void writeToFile({required EventListModel event, required String filePath}) {
    List<EventListModel> newData = [event];
    File fileName = File(filePath);
    List<dynamic> oldData = jsonDecode(fileName.readAsStringSync());
    //to removing duplicates
    oldData.toSet().toList();
    oldData.addAll(newData);
    fileName.writeAsStringSync(jsonEncode(oldData));
    firebaseServices.uploadFileToCloud(userEventsFile: oldData, merge: false);
  }

  //For adding items to event list
  void addNewEvent(
      {required String id,
      required int notificationId,
      required String title,
      required String notes,
      required DateTime dateTime,
      required String eventType,
      required bool fileExists,
      required BuildContext parentContext,
      String? filePath}) {
    //body part

    _allEvents.add(EventListModel(
      id: id,
      notificationId: notificationId,
      title: title,
      notes: notes,
      dateTime: dateTime,
      eventDate: dateTime.toString(),
      eventType: eventType,
    ));

    //storing into file
    EventListModel newData = EventListModel(
      id: id,
      notificationId: notificationId,
      title: title,
      notes: notes,
      dateTime: dateTime,
      eventDate: dateTime.toString(),
      eventType: eventType,
    );
    if (fileExists) {
      writeToFile(event: newData, filePath: filePath!);
    } else {
      createFile(content: newData, parentContext: parentContext);
    }
    notifyListeners();
  }

  //function to delete an event from list
  void deleteEvent({required String id, required String filePath}) {
    _allEvents.removeWhere((element) => element.toString().contains(id));
    //writing the data to file
    File fileName = File(filePath);
    fileName.writeAsStringSync(jsonEncode(_allEvents));
    firebaseServices.uploadFileToCloud(
        userEventsFile: _allEvents, merge: false);
    notifyListeners();
  }

  //cloud uploading function
  //For adding items to event list
  void addNewEventFromCloud(
      {required String id,
      required int notificationId,
      required String title,
      required String notes,
      required DateTime dateTime,
      required String eventType,
      required bool fileExists,
      required BuildContext parentContext,
      String? filePath}) {
    //body part

    // _allEvents.add(eventData);
    int flag = 0;
    for (var i in _allEvents) {
      final data = jsonDecode(i);
      if (data['id'] == id) {
        flag += 1;
      }
    }
    if (flag == 0) {
      //storing into file
      EventListModel newData = EventListModel(
        id: id,
        notificationId: notificationId,
        title: title,
        notes: notes,
        dateTime: dateTime,
        eventDate: dateTime.toString(),
        eventType: eventType,
      );
      _allEvents.add(newData);
      if (fileExists) {
        List<EventListModel> data = [newData];
        File fileName = File(filePath!);
        List<dynamic> oldData = jsonDecode(fileName.readAsStringSync());
        oldData.addAll(data);
        fileName.writeAsStringSync(jsonEncode(oldData));
      } else {
        List<EventListModel> data = [newData];
        getApplicationDocumentsDirectory().then((dir) {
          final name = '${dir.path}/userEvents';
          File fileName = File(name);
          fileName.createSync();
          fileName.writeAsStringSync(jsonEncode(data));
          //updating the cubit
          parentContext
              .read<EventFileHandlerCubit>()
              .fileExists(filePath: name);
        });
      }
    }
    notifyListeners();
  }
}
