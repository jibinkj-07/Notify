import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:mynotify/constants/app_colors.dart';
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

    //calling readData only if filepath is exist
    if (filePath != '') {
      userEvents = eventProvider.readDataFromFile(filePath: filePath);
    }

    //adding events from device into calender
    if (userEvents.isNotEmpty) {
      Color eventColor = appColors.greenColor;
      String about = 'Completed event';
      for (var i in userEvents) {
        // final event = jsonDecode(i);
        final DateTime time =
            DateTime.fromMillisecondsSinceEpoch(i['dateTime']);
        log('event time is $time and current time is ${DateTime.now()} and status is $about title is ${i['title']}');
        //checking if the event is over or not
        if (!time.isBefore(DateTime.now().toUtc())) {
          eventColor = appColors.primaryColor;
          log('${i['title']}');
          about = 'Upcoming event';
        }

        final calEvent = NeatCleanCalendarEvent(
          i['title'],
          description: '${i['eventType']}, $about',
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
                  print(value.description);
                },
                isExpandable: true,
                eventDoneColor: Colors.green,
                selectedColor: appColors.primaryColor,
                selectedTodayColor: Colors.deepOrange,
                todayColor: appColors.primaryColor,
                eventColor: appColors.primaryColor,
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
    );
  }
}
