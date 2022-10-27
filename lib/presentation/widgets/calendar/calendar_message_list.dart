import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/presentation/widgets/calendar/calendar_message_list_item.dart';

class CalendarMessageList extends StatelessWidget {
  const CalendarMessageList({
    super.key,
    required this.screen,
    required this.currentUserId,
    required this.appColors,
  });
  final Size screen;
  final String currentUserId;
  final AppColors appColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screen.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //MAIN BODY PART

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('AllUserEvents')
                .doc(currentUserId.trim().toString())
                .collection('SharedCalendar')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appColors.primaryColor,
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                // log('legnth is ${snapshot.data!.docs.toString()}');
                if (snapshot.data!.docs.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/illustrations/no_events.svg',
                          height: 100,
                        ),
                        const Text(
                          "No shared calendar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx1, i) {
                          DateTime date =
                              snapshot.data!.docs[i].get('time').toDate();

                          return CalendarMessageListItem(
                              date: date,
                              currentUserId: currentUserId,
                              sharedUserId: snapshot.data!.docs[i].id);
                        }),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
    ;
  }
}
