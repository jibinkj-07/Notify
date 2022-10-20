import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:provider/provider.dart';
import 'package:mynotify/constants/app_colors.dart';

import '../../logic/services/notification_service.dart';

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
    _endTime = _startTime.add(const Duration(days: 1));
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

    const List<String> _eventNames = <String>[
      'Birthday',
      'Anniversary',
      'Work',
      'Marriage',
      'Engagement',
      'Meeting',
      'Travel',
      'Party',
      'Exam',
      'Reminder',
      'Other',
    ];

    // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker.
    void _showDialog(Widget child) {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors().primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashRadius: 20.0,
        ),
        titleSpacing: 0,
        title: Text(
          "New Event",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors().primaryColor,
          ),
        ),
        actions: [
          //right portion
          _title.trim() != ''
              ? BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
                  builder: (ctx, state) {
                    if (state.isFileExists) {
                      return TextButton(
                        onPressed: () {
                          String notiBody =
                              'There is an event of type ${_eventNames[_selectedEvent]} in 5 minutes.Check it out';
                          Random random = Random();
                          final currentTime = DateTime.now();
                          int notificationId =
                              random.nextInt(999999999) + 1000000000;

                          //main part
                          Provider.of<EventDataServices>(context, listen: false)
                              .addNewEvent(
                                  id: currentTime.toString(),
                                  notificationId: notificationId,
                                  title: _title,
                                  notes: _notes,
                                  startTime: _startTime,
                                  endTime: _endTime,
                                  eventType: _eventNames[_selectedEvent],
                                  fileExists: true,
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
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors().primaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    } else {
                      return TextButton(
                        onPressed: () {
                          String notiBody =
                              'There is an event of type ${_eventNames[_selectedEvent]} in 5 minutes.Check it out';
                          Random random = Random();
                          final currentTime = DateTime.now();
                          int notificationId =
                              random.nextInt(999999999) + 1000000000;

                          NotificationService().showNotification(
                            id: notificationId,
                            title: _title,
                            body: notiBody,
                            dateTime: _startTime,
                          );

                          Provider.of<EventDataServices>(context, listen: false)
                              .addNewEvent(
                            id: currentTime.toString(),
                            notificationId: notificationId,
                            title: _title,
                            notes: _notes,
                            startTime: _startTime,
                            endTime: _endTime,
                            eventType: _eventNames[_selectedEvent],
                            parentContext: context,
                            fileExists: false,
                            isSyncing: false,
                          );
                          _titleController.clear();
                          _notesController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors().primaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    }
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: SizedBox(
            width: screen.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //form

                Container(
                  width: screen.width * .9,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        key: const ValueKey('title'),
                        controller: _titleController,
                        onChanged: (value) {
                          setState(() {
                            _title = value.trim();
                          });
                        },
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLength: 25,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        height: 1,
                      ),
                      TextField(
                        key: const ValueKey('note'),
                        controller: _notesController,
                        minLines: 1,
                        maxLines: 10,
                        onChanged: (value) {
                          _notes = value.trim();
                        },
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          hintText: 'Note',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                //Start time
                Container(
                  width: screen.width * .9,
                  margin: const EdgeInsets.only(top: 20),
                  child: Material(
                    color: Colors.grey.withOpacity(.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showDialog(
                          CupertinoDatePicker(
                            minimumYear: 1800,
                            maximumYear: 2300,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (value) {
                              setState(() {
                                _startTime = value;
                              });
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Start Time",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('dd MMM')
                                      .add_jm()
                                      .format(_startTime),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors().primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors().primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //End time
                Container(
                  width: screen.width * .9,
                  margin: const EdgeInsets.only(top: 20),
                  child: Material(
                    color: Colors.grey.withOpacity(.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showDialog(
                          CupertinoDatePicker(
                            minimumYear: 1800,
                            maximumYear: 2300,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (value) {
                              setState(() {
                                _endTime = value;
                              });
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "End Time",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('dd MMM')
                                      .add_jm()
                                      .format(_endTime),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors().primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors().primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                //event type
                Container(
                  width: screen.width * .9,
                  margin: const EdgeInsets.only(top: 20),
                  child: Material(
                    color: Colors.grey.withOpacity(.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showDialog(
                          CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: _selectedEvent),
                            magnification: 1.2,
                            squeeze: 1.4,
                            useMagnifier: true,
                            itemExtent: 30,
                            // This is called when selected item is changed.
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                _selectedEvent = selectedItem;
                              });
                            },
                            children: List<Widget>.generate(_eventNames.length,
                                (int index) {
                              return Center(
                                child: Text(
                                  _eventNames[index],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Event Type",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _eventNames[_selectedEvent],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors().primaryColor),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors().primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //end of main column
              ],
            ),
          ),
        ),
      ),
    );
  }
}
