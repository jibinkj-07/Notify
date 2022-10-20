import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../logic/services/event_data_services.dart';
import '../../../logic/services/notification_service.dart';

class EventListItem extends StatelessWidget {
  final String id;
  final int notificationId;
  final String filePath;
  final String title;
  final String notes;
  final String eventType;
  final DateTime dateTime;
  const EventListItem({
    required this.id,
    required this.title,
    required this.notes,
    required this.eventType,
    required this.dateTime,
    required this.notificationId,
    required this.filePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newNotes = notes.replaceAll("\n", " ");
    if (newNotes.length > 30) {
      newNotes = newNotes.substring(0, 25);
      newNotes = '$newNotes...';
    }
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors().redColor.withOpacity(.9),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        NotificationService().cancelNotification(id: notificationId);

        Provider.of<EventDataServices>(context, listen: false)
            .deleteEvent(id: id, filePath: filePath);
      },

      //child
      child: Container(
        padding: const EdgeInsets.all(15),
        // margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.withOpacity(.15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (eventType == 'Birthday')
                  Icon(
                    Iconsax.cake,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Anniversary')
                  Icon(
                    Iconsax.star,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Work')
                  Icon(
                    Iconsax.building_3,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Marriage')
                  Icon(
                    Iconsax.lovely,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Engagement')
                  Icon(
                    Iconsax.medal_star,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Meeting')
                  Icon(
                    Iconsax.brifecase_timer,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Travel')
                  Icon(
                    Iconsax.routing,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Party')
                  Icon(
                    Icons.celebration_rounded,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Exam')
                  Icon(
                    Iconsax.teacher,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Reminder')
                  Icon(
                    Iconsax.notification_status,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
                if (eventType == 'Other')
                  Icon(
                    Iconsax.calendar_1,
                    color: AppColors().primaryColor,
                    size: 35.0,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            //event type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  eventType,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors().primaryColor),
                ),
                //time
                Text(
                  DateFormat.jm().format(dateTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
