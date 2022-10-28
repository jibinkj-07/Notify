import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:notify/constants/app_colors.dart';
import 'package:notify/presentation/widgets/calendar/calendarEvent.dart';
import 'package:notify/util/event.dart';
import 'package:table_calendar/table_calendar.dart';

class SharedCalendarView extends StatefulWidget {
  final List<dynamic> userSharedEvents;
  final DateTime initTime;
  final String sharedUser;
  const SharedCalendarView({
    Key? key,
    required this.userSharedEvents,
    required this.initTime,
    required this.sharedUser,
  }) : super(key: key);

  @override
  State<SharedCalendarView> createState() => _SharedCalendarViewState();
}

class _SharedCalendarViewState extends State<SharedCalendarView> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<String, List<Event>> _eventsFromCalendar;

  @override
  void initState() {
    _selectedDay = widget.initTime;
    _focusedDay = widget.initTime;
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
    AppColors appColors = AppColors();
    _eventsFromCalendar = {};

//adding events from device into calender
    if (widget.userSharedEvents.isNotEmpty) {
      for (var i in widget.userSharedEvents) {
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
        title: Text(
          'Calendar View of ${widget.sharedUser}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
        titleSpacing: 0,
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
            thickness: 1.5,
            indent: 15,
            endIndent: 15,
          ),
          //EVENT LIST

          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: (_eventsFromCalendar[DateTime(_selectedDay.year,
                            _selectedDay.month, _selectedDay.day)
                        .toString()] !=
                    null)
                ? Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        final time = DateTime(_selectedDay.year,
                                _selectedDay.month, _selectedDay.day)
                            .toString();
                        String id =
                            _eventsFromCalendar[time]![index].toString();

                        //checking in userevents
                        final resultEvent = widget.userSharedEvents.firstWhere(
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
                            isSharedView: true,
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
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: SvgPicture.asset(
                          'assets/images/illustrations/no_events.svg',
                          height: 100,
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
