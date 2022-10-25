import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/presentation/screens/calendar_message_screen.dart';
import 'package:mynotify/presentation/screens/home/add_event_screen.dart';
import 'package:mynotify/presentation/widgets/calendar/calendarEvent.dart';
import 'package:mynotify/presentation/widgets/calendar/calendar_message_send.dart';
import 'package:mynotify/util/event.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../logic/services/event_data_services.dart';

class CalenderScreen extends StatefulWidget {
  final String filePath;
  const CalenderScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<String, List<Event>> _eventsFromCalendar;

  @override
  void initState() {
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _eventsFromCalendar = {};
    super.initState();
  }

  List<dynamic> _getEventsfromDay(DateTime date) {
    final selectedDate = DateTime(date.year, date.month, date.day).toString();
    return _eventsFromCalendar[selectedDate] ?? [];
  }

  //main
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> userEvents = [];
    AppColors appColors = AppColors();
    final eventProvider = Provider.of<EventDataServices>(context);
    _eventsFromCalendar = {};

    //calling readData only if filepath is exist
    if (widget.filePath != '') {
      userEvents = eventProvider.readDataFromFile(filePath: widget.filePath);
    }
//adding events from device into calender
    if (userEvents.isNotEmpty) {
      for (var i in userEvents) {
        final DateTime time =
            DateTime.fromMillisecondsSinceEpoch(i['startTime']);
        final eventDateString =
            DateTime(time.year, time.month, time.day).toString();
        if (_eventsFromCalendar[eventDateString] != null) {
          _eventsFromCalendar[eventDateString]!.add(Event(id: i['id']));
        } else {
          _eventsFromCalendar[eventDateString] = [
            Event(id: i['id']),
          ];
        }
      }
    }

    //main part
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          splashRadius: 20.0,
        ),
        actions: [
          //chat button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  reverseDuration: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 300),
                  type: PageTransitionType.rightToLeft,
                  child: const CalendarMessageScreen(),
                ),
              );
            },
            icon: const Icon(
              Iconsax.sms,
            ),
            splashRadius: 20.0,
          ),
          //add event button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  reverseDuration: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 300),
                  type: PageTransitionType.fade,
                  child: CalendarMessageSend(sharingDateTime: _selectedDay),
                ),
              );
            },
            icon: const Icon(
              Icons.share,
            ),
            splashRadius: 20.0,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(1800, 01, 01),
            lastDay: DateTime.utc(2300, 12, 30),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

            //calender style
            calendarStyle: CalendarStyle(
              todayTextStyle: TextStyle(
                  color: appColors.primaryColor, fontWeight: FontWeight.bold),
              todayDecoration: BoxDecoration(
                border: Border.all(width: 1.5, color: appColors.primaryColor),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: appColors.primaryColor,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
              markerSize: 6,
              markersOffset: const PositionedOffset(bottom: 10),
              markerDecoration: BoxDecoration(
                  color: appColors.primaryColor, shape: BoxShape.circle),
              markersAutoAligned: false,
              weekendTextStyle: TextStyle(color: appColors.redColor),
            ),
            //header style
            headerStyle: HeaderStyle(
              decoration: BoxDecoration(color: appColors.primaryColor),
              headerPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              headerMargin: const EdgeInsets.only(bottom: 10),
              titleCentered: false,
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              // leftChevronIcon: const Icon(
              //   Iconsax.arrow_circle_left5,
              //   color: Colors.white,
              // ),
              // rightChevronIcon: const Icon(
              //   Iconsax.arrow_circle_right5,
              //   color: Colors.white,
              // ),
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),

            //others
            weekendDays: const [DateTime.sunday],
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              // log(_selectedDay.toString());
            },
            calendarFormat: CalendarFormat.month,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday) {
                  final text = DateFormat.E().format(day);
                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: appColors.redColor,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return null;
              },
            ),
            eventLoader: _getEventsfromDay,
          ),
          const SizedBox(height: 10),
          const Divider(
            height: 0,
            indent: 15,
            endIndent: 15,
          ),
          //EVENT LIST

          if (_eventsFromCalendar[DateTime(
                      _selectedDay.year, _selectedDay.month, _selectedDay.day)
                  .toString()] !=
              null)
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return false;
              },
              child: Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    final time = DateTime(_selectedDay.year, _selectedDay.month,
                            _selectedDay.day)
                        .toString();
                    String id = _eventsFromCalendar[time]![index].toString();

                    //checking in userevents
                    final resultEvent = userEvents.firstWhere(
                        (element) => element.toString().contains(id));
                    final startTime = DateTime.fromMillisecondsSinceEpoch(
                        resultEvent['startTime']);
                    final endTime = DateTime.fromMillisecondsSinceEpoch(
                        resultEvent['endTime']);

                    return Container(
                      margin: const EdgeInsets.all(8),
                      child: CalendarEvent(
                        id: id,
                        notificationId: resultEvent['notificationId'],
                        title: resultEvent['title'],
                        notes: resultEvent['notes'],
                        eventType: resultEvent['eventType'],
                        startTime: startTime,
                        endTime: endTime,
                      ),
                    );
                  },
                  itemCount: _eventsFromCalendar[DateTime(_selectedDay.year,
                              _selectedDay.month, _selectedDay.day)
                          .toString()]!
                      .length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              reverseDuration: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 300),
              type: PageTransitionType.bottomToTop,
              child: AddEventScreen(selectedDateTime: _selectedDay),
            ),
          );
        },
        child: const Icon(
          Iconsax.note_add5,
          size: 30,
        ),
      ),
    );
  }
}
