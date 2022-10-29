import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notify/constants/app_colors.dart';
import 'package:notify/presentation/widgets/calendar/message_item.dart';

class MessageBody extends StatelessWidget {
  const MessageBody(
      {Key? key, required this.currentUserid, required this.targetUserid})
      : super(key: key);
  final String currentUserid;
  final String targetUserid;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('AllUserEvents')
            .doc(currentUserid)
            .collection('SharedCalendar')
            .doc(targetUserid)
            .collection('SharedEvents')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors().primaryColor,
              ),
            );
          }
          if (snapshot.hasData) {
            final document = snapshot.data?.docs;

            //if chat screen is empty
            if (snapshot.data!.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/illustrations/no_events.svg',
                    height: 100,
                  ),
                  const Text(
                    "No shared events",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            }
            //change the read status to false
            FirebaseFirestore.instance
                .collection('AllUserEvents')
                .doc(currentUserid)
                .collection('SharedCalendar')
                .doc(targetUserid)
                .set({'read': true}, SetOptions(merge: true));

            //list
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                  reverse: true,
                  itemCount: document!.length,
                  itemBuilder: (ctx, index) {
                    final mode = snapshot.data!.docs[index].get('mode');
                    final type =
                        snapshot.data!.docs[index].get('sharingOption');
                    final dateTime =
                        snapshot.data!.docs[index].get('time').toDate();
                    final name = snapshot.data!.docs[index].get('name');
                    final events =
                        jsonDecode(snapshot.data!.docs[index].get('allEvents'));
                    final sharedViewDate =
                        snapshot.data!.docs[index].get('sharedViewDate');
                    return MessageItem(
                      mode: mode,
                      dateTime: dateTime,
                      sharedUser: name,
                      calendarEvents: events,
                      type: type,
                      currentUserid: currentUserid,
                      targetUserid: targetUserid,
                      messageId: snapshot.data!.docs[index].id,
                      sharedViewDate: sharedViewDate,
                    );
                  }),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
