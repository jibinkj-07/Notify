import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:mynotify/models/event_list_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';

class EventList extends StatelessWidget {
  final String currentDateTime;
  const EventList({Key? key, required this.currentDateTime}) : super(key: key);

  //MAIN
  @override
  Widget build(BuildContext context) {
    log('builidng');
    dynamic userEvents = [];
    final eventsProvider = Provider.of<EventDataServices>(context);

    //Calling init state for file handler
    eventsProvider.initFileStorage();

    //reading data from file handelers
    userEvents = eventsProvider.readDataFromFile();
    // if (_fileExists) {
    //   log('Called read part');
    //   userEvents =
    //       eventsProvider.readDataFromFile(_fileDirectory, _fileName).toList();
    // }
    //calling init file function
    // eventListProvider.initFileStorage();

//sorting all events list items
    // var sortedEvents = Map.fromEntries(
    //     eventListProvider.allEvents.toList()
    //       ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    // return Center(
    //   child: Text("BODY"),
    // );

    // log(data.toString());

    // return Center(
    //   child: ListView.builder(
    //     itemBuilder: (ctx, i) {
    //       Map eventItem = jsonDecode(data[i]);
    //       final time =
    //           DateTime.fromMillisecondsSinceEpoch(eventItem['dateTime']);
    //       if (eventItem['id'].toString().contains(widget.currentDateTime)) {
    //         return ListTile(
    //           title: Text(eventItem['title']),
    //           subtitle: Text(DateFormat.jm().format(time)),
    //           trailing: Text(eventItem['eventType']),
    //         );
    //       } else {
    //         return const SizedBox();
    //       }
    //     },
    //     itemCount: data.length,
    //   ),
    // );
    log('user events is $userEvents');
    return (userEvents != '' &&
            userEvents != false &&
            userEvents.toString().contains(currentDateTime))
        ? NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  Map eventItem = jsonDecode(userEvents[index]);
                  final time = DateTime.fromMillisecondsSinceEpoch(
                      eventItem['dateTime']);
                  if (eventItem['id'].toString().contains(currentDateTime)) {
                    return ListTile(
                      title: Text(eventItem['title']),
                      subtitle: Text(DateFormat.jm().format(time)),
                      trailing: Text(eventItem['eventType']),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                itemCount: userEvents.length,
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.note_text,
                  color: AppColors().primaryColor,
                  size: 50,
                ),
                Text(
                  "No Events",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors().primaryColor),
                )
              ],
            ),
          );
  }
}
