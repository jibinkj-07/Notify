import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';

class EventListItem extends StatelessWidget {
  final String id;
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageName = eventType.toLowerCase();
    String newNotes = notes.replaceAll("\n", " ");
    if (newNotes.length > 30) {
      newNotes = newNotes.substring(0, 25);
      newNotes = '$newNotes...';
    }
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                  Iconsax.cake5,
                  color: AppColors().primaryColor,
                  size: 35.0,
                ),
              if (eventType == 'Travel')
                Icon(
                  Iconsax.routing,
                  color: AppColors().primaryColor,
                  size: 35.0,
                ),
              if (eventType == 'Meeting')
                Icon(
                  Iconsax.brifecase_timer5,
                  color: AppColors().primaryColor,
                  size: 35.0,
                ),
              if (eventType == 'Exam')
                Icon(
                  Iconsax.menu_board5,
                  color: AppColors().primaryColor,
                  size: 35.0,
                ),
              if (eventType == 'Alert')
                Icon(
                  Iconsax.alarm5,
                  color: AppColors().primaryColor,
                  size: 35.0,
                ),
              if (eventType == 'Others')
                Icon(
                  Iconsax.calendar_25,
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

          //notes
          // Text(
          //   '  $newNotes',
          //   style: const TextStyle(
          //     fontSize: 16,
          //   ),
          // ),
        ],
      ),
    );
  }
}
