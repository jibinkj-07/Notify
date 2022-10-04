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
import 'package:mynotify/presentation/screens/user_events_list_details.dart';
import 'package:mynotify/presentation/widgets/homescreen/event_list_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';

class EventList extends StatelessWidget {
  final String currentDateTime;
  const EventList({Key? key, required this.currentDateTime}) : super(key: key);

  //MAIN
  @override
  Widget build(BuildContext context) {
    // log('current date from prev page is $currentDateTime');
    dynamic userEvents = [];
    final eventsProvider = Provider.of<EventDataServices>(context);

    //checking for is file created already
    return BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
        builder: (context, state) {
      if (state.isFileExists) {
        //CALLING READ FUNC FROM PROVIDER
        userEvents = eventsProvider.readDataFromFile(filePath: state.filePath);

        //Checking whether current day has any events, if not displaying no events widget
        if (!userEvents.toString().contains(currentDateTime)) {
          // log('No user events in this day');
          return noEvents();
        }
        // log(userEvents.toString());

        //Returing listview
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                Map eventItem = jsonDecode(userEvents[index]);
                final id = eventItem['id'].toString();
                final title = eventItem['title'].toString();
                final notes = eventItem['notes'].toString();
                int notiID = eventItem['notificationId'];
                final time =
                    DateTime.fromMillisecondsSinceEpoch(eventItem['dateTime']);
                final eventType = eventItem['eventType'].toString();
                // log('time is $time');
                if (time.toString().contains(currentDateTime)) {
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          //MOVING INTO DETAIL SCREEN
                          Navigator.push(
                            context,
                            PageTransition(
                              reverseDuration:
                                  const Duration(milliseconds: 300),
                              duration: const Duration(milliseconds: 300),
                              type: PageTransitionType.rightToLeft,
                              child: UserEventListDetails(
                                  id: id,
                                  notificationId: notiID,
                                  title: title,
                                  notes: notes,
                                  dateTime: time,
                                  eventType: eventType),
                            ),
                          );
                        },
                        child: EventListItem(
                            id: id,
                            title: title,
                            notes: notes,
                            eventType: eventType,
                            dateTime: time),
                      ),
                      // const Divider(
                      //   height: 1,
                      //   // thickness: 1,
                      //   indent: 20.0,
                      // ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
              itemCount: userEvents.length,
            ),
          ),
        );
      } else {
        return noEvents();
      }
    });
  }

  Center noEvents() {
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
}
