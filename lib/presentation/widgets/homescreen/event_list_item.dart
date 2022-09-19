import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: AssetImage('assets/images/$imageName.png'),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  //event type
                  Text(
                    eventType,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors().primaryColor),
                  ),

                  //notes
                  Text(
                    '  $newNotes',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  //time type
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      DateFormat.jm().format(dateTime),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
