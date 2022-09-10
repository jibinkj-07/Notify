import 'package:flutter/material.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                image: const DecorationImage(
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                  image: AssetImage(
                    'assets/images/others.png',
                  ),
                ),
                color: Colors.transparent),
          ),
          const SizedBox(height: 10),
          const Text(
            "Title",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          Text(
            'notes',
            style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(.5),
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
