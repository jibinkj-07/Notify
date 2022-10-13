import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/presentation/screens/add_event_screen.dart';
import 'package:mynotify/presentation/screens/user_events_list_details.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../logic/services/event_data_services.dart';

class CalenderScreen extends StatelessWidget {
  final String filePath;
  const CalenderScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> userEvents = [];
    List<NeatCleanCalendarEvent> calenderEventList = [];
    AppColors appColors = AppColors();
    final eventProvider = Provider.of<EventDataServices>(context);
    DateTime selectedDateTime = DateTime.now();

    //calling readData only if filepath is exist
    if (filePath != '') {
      userEvents = eventProvider.readDataFromFile(filePath: filePath);
    }

    //adding events from device into calender
    if (userEvents.isNotEmpty) {
      Color eventColor = appColors.redColor;
      String about = 'Completed';
      for (var i in userEvents) {
        final DateTime time =
            DateTime.fromMillisecondsSinceEpoch(i['dateTime']);

        //checking if the event is over or not
        if (!time.isBefore(DateTime.now().toUtc())) {
          eventColor = appColors.greenColor;
          about = 'Upcoming';
        }

        final calEvent = NeatCleanCalendarEvent(
          i['title'],
          description: '${i['eventType']}, $about',
          location:
              '${i['id']},${i['notificationId']},${i['notes']},${i['dateTime']},${i['eventType']},',
          color: eventColor,
          startTime: time,
          endTime: DateTime(
            time.year,
            time.month,
            time.day,
            23,
            59,
          ),
        );
        calenderEventList.add(calEvent);
      }
    }

    //main part
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //back button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appColors.primaryColor,
                ),
              ),
            ),
            //calender View
            Expanded(
              child: Calendar(
                defaultDayColor: Colors.black,
                startOnMonday: false,
                weekDays: const [
                  'Sun',
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat'
                ],
                eventsList: calenderEventList,
                onEventSelected: (value) {
                  final data = value.location.split(',');
                  log(data[0].toString());
                  final id = data[0].toString();
                  final notificationId = int.parse(data[1]);
                  final title = value.summary;
                  final notes = data[2];
                  final dateTime =
                      DateTime.fromMillisecondsSinceEpoch(int.parse(data[3]));
                  final eventType = data[4];

                  Navigator.push(
                    context,
                    PageTransition(
                      reverseDuration: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 300),
                      type: PageTransitionType.rightToLeft,
                      child: UserEventListDetails(
                          id: id,
                          notificationId: notificationId,
                          title: title,
                          notes: notes,
                          dateTime: dateTime,
                          eventType: eventType),
                    ),
                  );
                },
                onDateSelected: (value) {
                  selectedDateTime = value;
                },
                isExpandable: true,
                eventDoneColor: Colors.green,
                selectedColor: appColors.primaryColor,
                selectedTodayColor: appColors.redColor,
                todayColor: appColors.redColor,
                eventColor: appColors.primaryColor,
                hideTodayIcon: true,
                locale: 'en_US',
                todayButtonText: '',
                allDayEventText: '',
                multiDayEndText: '',
                isExpanded: true,
                expandableDateFormat: 'EEEE, dd MMMM yyyy',
                dayOfWeekStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                bottomBarColor: Colors.grey.withOpacity(.1),
                bottomBarArrowColor: appColors.primaryColor,
                bottomBarTextStyle: TextStyle(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                displayMonthTextStyle: TextStyle(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              reverseDuration: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 300),
              type: PageTransitionType.bottomToTop,
              child: AddEventScreen(selectedDateTime: selectedDateTime),
            ),
          );
        },
        backgroundColor: AppColors().primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(
          Iconsax.note_add5,
          size: 30,
        ),
      ),
    );
  }
}
