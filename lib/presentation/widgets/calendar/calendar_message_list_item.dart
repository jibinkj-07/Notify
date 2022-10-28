import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/presentation/widgets/calendar/messages.dart';

import '../../../logic/services/firebase_services.dart';

class CalendarMessageListItem extends StatefulWidget {
  const CalendarMessageListItem({
    super.key,
    required this.date,
    required this.currentUserId,
    required this.sharedUserId,
    required this.readStatus,
  });
  final DateTime date;
  final String currentUserId;
  final String sharedUserId;
  final bool readStatus;

  @override
  State<CalendarMessageListItem> createState() =>
      _CalendarMessageListItemState();
}

class _CalendarMessageListItemState extends State<CalendarMessageListItem> {
  String userName = 'User';
  String gender = 'male';
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('AllUserEvents')
        .doc(widget.sharedUserId)
        .get()
        .then((DocumentSnapshot data) {
      setState(() {
        userName = data.get('username');
        gender = data.get('gender');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('yyyy-MM-dd');
    String sharedDate = formatter.format(widget.date);
    String todayDate = formatter.format(DateTime.now());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: userName == 'User'
              ? ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.withOpacity(.2),
                  ),
                  title: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withOpacity(.2),
                    ),
                  ),
                )
              : Dismissible(
                  key: ValueKey(widget.sharedUserId),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors().redColor.withOpacity(.8),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      // size: 30,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    FirebaseServices().deleteChatUser(
                      currentUserId: widget.currentUserId,
                      targetUserId: widget.sharedUserId,
                    );
                  },
                  child: ListTile(
                    leading: SvgPicture.asset(
                      'assets/images/illustrations/${gender}_avatar.svg',
                      height: 50,
                    ),
                    subtitle: widget.readStatus
                        ? null
                        : Text(
                            'New calendar view',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors().primaryColor),
                          ),
                    title: Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: sharedDate == todayDate
                        ? Text(
                            DateFormat.jm().format(widget.date),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: widget.readStatus
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          )
                        : Text(
                            DateFormat.MMMd().format(widget.date),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: widget.readStatus
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Messages(
                              username: userName,
                              gender: gender,
                              currentUserId: widget.currentUserId,
                              sharedUserId: widget.sharedUserId),
                        ),
                      );
                    },
                  ),
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
