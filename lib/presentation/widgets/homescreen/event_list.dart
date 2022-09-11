import 'package:flutter/material.dart';
import 'package:mynotify/models/event_list_model.dart';

import 'event_list_item.dart';

class EventList extends StatelessWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<EventListModel> list = [
      EventListModel(
          title: 'test1',
          notes: 'notes',
          dateTime: DateTime.now(),
          eventType: 'Birthday',
          alertMe: true),
      EventListModel(
          title: 'test2',
          notes: '',
          dateTime: DateTime.now(),
          eventType: 'Alert',
          alertMe: false),
      EventListModel(
          title: 'test3',
          notes: 'abc is the abc asdsa asd assd a',
          dateTime: DateTime.now(),
          eventType: 'Exam',
          alertMe: true),
    ];
    return // child: Center(
        //     child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Icon(
        //       Iconsax.note_text,
        //       color: AppColors().primaryColor,
        //       size: 50,
        //     ),
        //     Text(
        //       "No Events",
        //       style: TextStyle(
        //           fontSize: 18,
        //           fontWeight: FontWeight.w700,
        //           color: AppColors().primaryColor),
        //     )
        //   ],
        // )),
        NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SizedBox(
        width: double.infinity,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            final listData = list[index];
            return EventListItem(
              title: listData.title,
              notes: listData.notes,
              type: listData.eventType,
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }
}
