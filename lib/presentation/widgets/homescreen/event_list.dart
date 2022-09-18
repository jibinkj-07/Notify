import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
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
    dynamic userEvents = [];
    final eventsProvider = Provider.of<EventDataServices>(context);

    //checking for is file created already
    return BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
        builder: (context, state) {
      if (state.isFileExists) {
        final data = eventsProvider.readDataFromFile(filePath: state.filePath);
        log(data.toString());
        return Text('Yes file');
      } else {
        return Center(
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
    });

    // //reading data from file handelers
    // userEvents = eventsProvider.readDataFromFile();

    // return (userEvents != '' &&
    //         userEvents != false &&
    //         userEvents.toString().contains(currentDateTime))
    //     ? NotificationListener<OverscrollIndicatorNotification>(
    //         onNotification: (overscroll) {
    //           overscroll.disallowIndicator();
    //           return true;
    //         },
    //         child: SizedBox(
    //           width: double.infinity,
    //           child: ListView.builder(
    //             itemBuilder: (ctx, index) {
    //               Map eventItem = jsonDecode(userEvents[index]);
    //               final time = DateTime.fromMillisecondsSinceEpoch(
    //                   eventItem['dateTime']);
    //               if (eventItem['id'].toString().contains(currentDateTime)) {
    //                 return ListTile(
    //                   title: Text(eventItem['title']),
    //                   subtitle: Text(DateFormat.jm().format(time)),
    //                   trailing: Text(eventItem['eventType']),
    //                 );
    //               } else {
    //                 return const SizedBox();
    //               }
    //             },
    //             itemCount: userEvents.length,
    //           ),
    //         ),
    //       )
    //     :
  }
}
