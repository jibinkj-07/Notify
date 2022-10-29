import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:notify/logic/cubit/event_file_handler_cubit.dart';
import 'package:notify/logic/services/event_data_services.dart';
import 'package:provider/provider.dart';
import 'package:notify/constants/app_colors.dart';

import '../../../logic/services/notification_service.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime? selectedDateTime;
  const AddEventScreen({
    Key? key,
    this.selectedDateTime,
  }) : super(
          key: key,
        );

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late String _notes;
  late String _title;
  late DateTime _startTime;
  late DateTime _endTime;
  int _selectedEvent = 0;

  @override
  void initState() {
    if (widget.selectedDateTime != null) {
      final time = widget.selectedDateTime!;
      _startTime = DateTime(time.year, time.month, time.day,
          DateTime.now().hour, DateTime.now().minute);
    } else {
      _startTime = DateTime.now();
    }
    _endTime =
        DateTime(_startTime.year, _startTime.month, _startTime.day, 23, 59);
    _notes = '';
    _title = '';
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //variables
    final screen = MediaQuery.of(context).size;
    final AppColors appColors = AppColors();

    const List<String> eventNames = <String>[
      'Birthday',
      'Anniversary',
      'Work',
      'Wedding',
      'Engagement',
      'Meeting',
      'Travel',
      'Party',
      'Exam',
      'Reminder',
      'Other',
    ];
    String eventImageName = eventNames[_selectedEvent].toLowerCase();

    // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker.
    void showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: screen.height * .25,
                // padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ));
    }

    //main
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: screen.width,
          //main column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //head section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Event",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: appColors.primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: appColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          //illustrator image for choosen events
                          SvgPicture.asset(
                            'assets/images/illustrations/events/$eventImageName.svg',
                            height: 200,
                          ),
                          const SizedBox(height: 8.0),
                          //title section
                          Container(
                            width: screen.width * .9,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              key: const ValueKey('title'),
                              // controller: _titleController,
                              onChanged: (value) {
                                setState(() {
                                  _title = value.trim();
                                });
                              },
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: appColors.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                              cursorColor: appColors.primaryColor,
                              maxLength: 25,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                hintText: 'Title',
                                hintStyle: TextStyle(
                                  color:
                                      appColors.primaryColor.withOpacity(.35),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          //note section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Notes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                width: screen.width * .9,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextField(
                                  key: const ValueKey('note'),
                                  controller: _notesController,
                                  minLines: 4,
                                  maxLines: 10,
                                  onChanged: (value) {
                                    _notes = value.trim();
                                  },
                                  keyboardType: TextInputType.multiline,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    hintText: 'eg: Most awaited moment....',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          //start time section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Start Time",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                width: screen.width * .9,
                                margin: const EdgeInsets.only(top: 5),
                                child: Material(
                                  color: Colors.grey.withOpacity(.2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      showDialog(
                                        CupertinoDatePicker(
                                          minimumYear: 1800,
                                          maximumYear: 2300,
                                          initialDateTime: _startTime,
                                          onDateTimeChanged: (value) {
                                            setState(() {
                                              _startTime = value;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('dd MMM')
                                                .add_jm()
                                                .format(_startTime),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: appColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          //end time section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "End Time",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                width: screen.width * .9,
                                margin: const EdgeInsets.only(top: 5),
                                child: Material(
                                  color: Colors.grey.withOpacity(.2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      showDialog(
                                        CupertinoDatePicker(
                                          minimumYear: 1800,
                                          maximumYear: 2300,
                                          initialDateTime: _endTime,
                                          onDateTimeChanged: (value) {
                                            setState(() {
                                              _endTime = value;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('dd MMM')
                                                .add_jm()
                                                .format(_endTime),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: appColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          //event type section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Event Type",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                width: screen.width * .9,
                                margin: const EdgeInsets.only(top: 5),
                                child: Material(
                                  color: Colors.grey.withOpacity(.2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      showDialog(
                                        CupertinoPicker(
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: _selectedEvent),
                                          magnification: 1.2,
                                          squeeze: 1.4,
                                          useMagnifier: true,
                                          itemExtent: 30,
                                          // This is called when selected item is changed.
                                          onSelectedItemChanged:
                                              (int selectedItem) {
                                            setState(() {
                                              _selectedEvent = selectedItem;
                                            });
                                          },
                                          children: List<Widget>.generate(
                                              eventNames.length, (int index) {
                                            return Center(
                                              child: Text(
                                                eventNames[index],
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            eventNames[_selectedEvent],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: appColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 20),

                          //end
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //add button
              BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
                builder: (context, state) {
                  return SizedBox(
                    width: screen.width * .9,
                    child: ElevatedButton(
                      onPressed: _title.trim() == ''
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              String notiBody =
                                  'Event of type ${eventNames[_selectedEvent]} in 5 minutes.Check it out';
                              Random random = Random();
                              final currentTime = DateTime.now();
                              int notificationId =
                                  random.nextInt(999999999) + 1000000000;

                              //main part
                              Provider.of<EventDataServices>(context,
                                      listen: false)
                                  .addNewEvent(
                                      id: currentTime.toString(),
                                      notificationId: notificationId,
                                      title: _title,
                                      notes: _notes,
                                      startTime: _startTime,
                                      endTime: _endTime,
                                      eventType: eventNames[_selectedEvent],
                                      fileExists: state.isFileExists,
                                      parentContext: context,
                                      filePath: state.filePath,
                                      isSyncing: false);

                              //notification part
                              NotificationService().showNotification(
                                id: notificationId,
                                title: _title,
                                body: notiBody,
                                dateTime: _startTime,
                              );
                              _titleController.clear();
                              _notesController.clear();
                              Navigator.of(context).pop();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.primaryColor,
                        disabledBackgroundColor:
                            appColors.primaryColor.withOpacity(.2),
                        disabledForegroundColor:
                            appColors.primaryColor.withOpacity(.4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Create",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              //end of main column
            ],
          ),
        ),
      ),
    );
  }
}
