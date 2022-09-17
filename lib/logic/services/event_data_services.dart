import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/event_list_model.dart';

class EventDataServices with ChangeNotifier {
  ///FILE HANDLERS
  late File _fileName;
  late Directory _fileDirectory;
  bool _fileExists = false;
  List<dynamic> _allEvents = [];

  //init

  void initFileStorage() {
    log('Initialising  file');
    getApplicationDocumentsDirectory().then((Directory directory) {
      _fileDirectory = directory;
      _fileName = File("${_fileDirectory.path}/all_event_datas");
      _fileExists = _fileName.existsSync();
    });
  }

  //Reading data from file
  dynamic readDataFromFile() {
    if (_fileExists) {
      _allEvents = jsonDecode(_fileName.readAsStringSync());
      return _allEvents;
    }
    return false;
  }

//CREATING FILE
  void createFile(EventListModel content) {
    log('creating file');
    List<EventListModel> newData = [content];
    File file = File("${_fileDirectory.path}/all_event_datas");
    _fileExists = true;
    file.createSync();
    file.writeAsStringSync(jsonEncode(newData));
  }

//WRITING DATA INTO FILE
  void writeToFile({required EventListModel event}) {
    log('writing into file');
    log('File exists in writing file section');
    List<EventListModel> newData = [event];
    File fileName = File("${_fileDirectory.path}/all_event_datas");
    List<dynamic> currentData = jsonDecode(fileName.readAsStringSync());
    currentData.addAll(newData);
    fileName.writeAsStringSync(jsonEncode(currentData));
  }

  //For adding items to event list
  void addNewEvent({
    required String id,
    required String title,
    required String notes,
    required DateTime dateTime,
    required String eventType,
    required bool alertMe,
  }) {
    //body part
    Directory fileDir;
    File fileName;
    bool fileExist = false;
    _allEvents.add(EventListModel(
        id: id,
        title: title,
        notes: notes,
        dateTime: dateTime,
        eventType: eventType,
        alertMe: alertMe));

    //storing into file
    EventListModel newData = EventListModel(
        id: id,
        title: title,
        notes: notes,
        dateTime: dateTime,
        eventType: eventType,
        alertMe: alertMe);
    getApplicationDocumentsDirectory().then((Directory directory) {
      fileDir = directory;
      fileName = File("${fileDir.path}/all_event_datas");
      fileExist = fileName.existsSync();

      if (fileExist) {
        writeToFile(event: newData);
      } else {
        createFile(newData);
      }
    });
    notifyListeners();
  }

  //clear all data from file
  void clearFile() {
    Directory fileDir;
    File fileName;
    bool fileExist = false;

    getApplicationDocumentsDirectory().then((Directory directory) {
      fileDir = directory;
      fileName = File("${fileDir.path}/all_event_datas");
      fileExist = fileName.existsSync();

      if (fileExist) {
        fileName.deleteSync();
        log('file delted');
      }
    });
    notifyListeners();
  }
}
