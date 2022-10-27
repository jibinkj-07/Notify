import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/services/firebase_services.dart';
import 'package:mynotify/presentation/widgets/calendar/shared_calendar_view.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.mode,
    required this.type,
    required this.dateTime,
    required this.sharedUser,
    required this.calendarEvents,
    required this.currentUserid,
    required this.messageId,
    required this.targetUserid,
  });
  final String mode;
  final String type;
  final DateTime dateTime;
  final String sharedUser;
  final String currentUserid;
  final String targetUserid;
  final String messageId;
  final List<dynamic> calendarEvents;

  @override
  Widget build(BuildContext context) {
    late DateTime sDate;
    final data = calendarEvents.first;
    sDate = DateTime.fromMillisecondsSinceEpoch(data['startTime']);

    var formatter = DateFormat('yyyy-MM-dd');
    String sharedDate = formatter.format(dateTime);
    String todayDate = formatter.format(DateTime.now());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: mode.toLowerCase() == 'sent'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SharedCalendarView(
                      userSharedEvents: calendarEvents,
                      initTime: sDate,
                      sharedUser: sharedUser,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Dismissible(
                key: ValueKey(dateTime.toString()),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(15),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors().redColor.withOpacity(.8),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  FirebaseServices().deleteSharedCalendarView(
                      currentUserId: currentUserid,
                      targetUserId: targetUserid,
                      id: messageId);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: mode.toLowerCase() == 'sent'
                          ? Colors.grey.withOpacity(.4)
                          : AppColors().primaryColor.withOpacity(.4),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: SvgPicture.asset(
                          'assets/images/illustrations/events/other.svg',
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$mode Calendar events of $type',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sharedDate == todayDate
                            ? DateFormat.jm().format(dateTime)
                            : DateFormat.MMMEd().add_jm().format(dateTime),
                        style: const TextStyle(
                            // fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
