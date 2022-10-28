import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../logic/cubit/event_file_handler_cubit.dart';
import '../../../logic/services/event_data_services.dart';
import '../../../logic/services/notification_service.dart';
import '../../screens/home/user_events_list_details.dart';

class CalendarEvent extends StatelessWidget {
  final String id;
  final int notificationId;
  final String title;
  final String notes;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType;
  final bool isSharedView;
  const CalendarEvent({
    Key? key,
    required this.id,
    required this.notificationId,
    required this.title,
    required this.notes,
    required this.eventType,
    required this.startTime,
    required this.endTime,
    required this.isSharedView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    String status = 'Upcoming';
    Color statusColor = appColors.greenColor;
    //checking if the event is over or not
    if (endTime.isBefore(DateTime.now().toUtc())) {
      status = 'Completed';
      statusColor = appColors.redColor;
    }
    if (startTime.isBefore(DateTime.now().toUtc()) &&
        endTime.isAfter(DateTime.now().toUtc())) {
      status = 'In Progress';
      statusColor = appColors.orangeColor;
    }

    //main
    return BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
      builder: (context, state) {
        return Dismissible(
          key: ValueKey(id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: AppColors().redColor.withOpacity(.9),
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              // size: 30,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            NotificationService().cancelNotification(id: notificationId);

            Provider.of<EventDataServices>(context, listen: false)
                .deleteEvent(id: id, filePath: state.filePath);
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isSharedView
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UserEventListDetails(
                            id: id,
                            notificationId: notificationId,
                            title: title,
                            notes: notes,
                            startTime: startTime,
                            endTime: endTime,
                            eventType: eventType),
                      ),
                    );
                  },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: statusColor.withOpacity(.25),
              ),
              child: Row(
                children: [
                  Container(
                    width: 15,
                    height: 100,

                    // height: double.infinity,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 85,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //title row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: statusColor),
                                    ),
                                    Text(
                                      eventType,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                //start time
                                Text(
                                  DateFormat.jm().format(startTime),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            //status row
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Status",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        status,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  //vertical line
                                  const VerticalDivider(
                                    thickness: 1.5,
                                    color: Colors.black38,
                                  ),
                                  //end time
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "End Time",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        DateFormat.MMMd()
                                            .add_jm()
                                            .format(endTime),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
