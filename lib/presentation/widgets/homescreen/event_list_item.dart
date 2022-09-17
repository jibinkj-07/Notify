import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatelessWidget {
  final String id;
  final String title;
  final String notes;
  final String type;
  final DateTime dateTime;
  const EventListItem({
    required this.id,
    required this.title,
    required this.notes,
    required this.type,
    required this.dateTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageName = type.toLowerCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                  image: AssetImage(
                    'assets/images/$imageName.png',
                  ),
                ),
                color: Colors.transparent),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(.8)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notes,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(.5),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                DateFormat.jm().format(dateTime),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(.6),
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
