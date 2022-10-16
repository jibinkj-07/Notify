import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:page_transition/page_transition.dart';

import '../../screens/user_events_list_details.dart';

class CalendarEvent extends StatelessWidget {
  final String id;
  final int notificationId;
  final String title;
  final String notes;
  final DateTime dateTime;
  final String eventType;
  const CalendarEvent({
    Key? key,
    required this.id,
    required this.notificationId,
    required this.title,
    required this.notes,
    required this.eventType,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    String status = 'Upcoming';
    Color statusColor = appColors.greenColor;

    //checking if the event is over or not
    if (dateTime.isBefore(DateTime.now().toUtc())) {
      status = 'Completed';
      statusColor = appColors.redColor;
    }

    //main
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      splashColor: appColors.primaryColor.withOpacity(.8),
      onTap: () {
        //MOVING INTO DETAIL SCREEN
        Navigator.push(
          context,
          PageTransition(
            reverseDuration: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 500),
            type: PageTransitionType.fade,
            child: UserEventListDetails(
                id: id,
                notificationId: notificationId,
                title: title,
                notes: notes,
                dateTime: dateTime,
                eventType: eventType),
          ),
        );
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appColors.primaryColor.withOpacity(.2),
        ),
        child: Row(
          children: [
            //event status bar
            Container(
              width: 15,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                // borderRadius: BorderRadius.circular(20),
                color: statusColor,
              ),
            ),
            //event details
            Expanded(
              child: SizedBox(
                height: 45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      eventType,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //event time
            SizedBox(
              height: 45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat.jm().format(dateTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
