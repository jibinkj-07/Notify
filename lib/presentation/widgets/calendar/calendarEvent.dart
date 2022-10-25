import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:page_transition/page_transition.dart';

import '../../screens/home/user_events_list_details.dart';

class CalendarEvent extends StatelessWidget {
  final String id;
  final int notificationId;
  final String title;
  final String notes;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType;
  const CalendarEvent({
    Key? key,
    required this.id,
    required this.notificationId,
    required this.title,
    required this.notes,
    required this.eventType,
    required this.startTime,
    required this.endTime,
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

    return GestureDetector(
      onTap: () {
        //MOVING INTO DETAIL SCREEN
        Navigator.push(
          context,
          PageTransition(
            reverseDuration: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300),
            type: PageTransitionType.fade,
            child: UserEventListDetails(
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
        // height: 50,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: statusColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  eventType,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            //event time
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Iconsax.calendar_15,
                  color: Colors.white,
                  // size: 25,
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat.jm().format(startTime),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  endTime.day != startTime.day
                      ? DateFormat.MMMd().add_jm().format(endTime)
                      : DateFormat.jm().format(endTime),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
