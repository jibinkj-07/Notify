import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/presentation/widgets/calendar/messages.dart';

class CalendarMessageListItem extends StatefulWidget {
  const CalendarMessageListItem({
    super.key,
    required this.date,
    required this.currentUserId,
    required this.sharedUserId,
  });
  final DateTime date;
  final String currentUserId;
  final String sharedUserId;

  @override
  State<CalendarMessageListItem> createState() =>
      _CalendarMessageListItemState();
}

class _CalendarMessageListItemState extends State<CalendarMessageListItem> {
  String userName = 'User';
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('AllUserEvents')
        .doc(widget.sharedUserId)
        .get()
        .then((DocumentSnapshot data) {
      setState(() {
        userName = data.get('username');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('yyyy-MM-dd');
    String sharedDate = formatter.format(widget.date);
    String todayDate = formatter.format(DateTime.now());

    return userName == 'User'
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/illustrations/male_avatar.svg',
                    height: 45,
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: sharedDate == todayDate
                      ? Text(DateFormat.jm().format(widget.date))
                      : Text(DateFormat.MMMd().format(widget.date)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Messages(
                            username: userName,
                            currentUserId: widget.currentUserId,
                            sharedUserId: widget.sharedUserId),
                      ),
                    );
                  },
                ),
              ),
              const Divider(
                height: 0,
                indent: 20,
              ),
            ],
          );
  }
}
