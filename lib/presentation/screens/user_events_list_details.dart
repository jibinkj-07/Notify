// ignore_for_file: unnecessary_string_escapes

import 'dart:developer' as dlog;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:mynotify/logic/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../logic/cubit/event_file_handler_cubit.dart';

class UserEventListDetails extends StatefulWidget {
  final String id, title, notes, eventType;
  final int notificationId;
  final DateTime startTime;
  final DateTime endTime;
  const UserEventListDetails(
      {Key? key,
      required this.id,
      required this.notificationId,
      required this.title,
      required this.notes,
      required this.startTime,
      required this.endTime,
      required this.eventType})
      : super(key: key);

  @override
  State<UserEventListDetails> createState() => _UserEventListDetailsState();
}

class _UserEventListDetailsState extends State<UserEventListDetails> {
  late String _notes;
  late String _title;
  DateTime? _startTime;
  DateTime? _endTime;
  late int _oldSelectedEvent;
  late int _selectedEvent;

  final List<String> _eventNames = <String>[
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
  @override
  void initState() {
    _notes = '';
    _title = '';
    _oldSelectedEvent = _eventNames.indexOf(widget.eventType);
    _selectedEvent = _eventNames.indexOf(widget.eventType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //variables
    final screen = MediaQuery.of(context).size;
    AppColors appColors = AppColors();

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

//event icon widget
    Widget eventIcon() {
      switch (_eventNames[_selectedEvent]) {
        case 'Birthday':
          return const Icon(
            Iconsax.cake,
            color: Colors.white,
            size: 100.0,
          );
        case 'Anniversary':
          return const Icon(
            Iconsax.star,
            color: Colors.white,
            size: 100.0,
          );
        case 'Work':
          return const Icon(
            Iconsax.building_3,
            color: Colors.white,
            size: 100.0,
          );
        case 'Marriage':
          return const Icon(
            Iconsax.lovely,
            color: Colors.white,
            size: 100.0,
          );
        case 'Engagement':
          return const Icon(
            Iconsax.medal_star,
            color: Colors.white,
            size: 100.0,
          );
        case 'Meeting':
          return const Icon(
            Iconsax.brifecase_timer,
            color: Colors.white,
            size: 100.0,
          );
        case 'Travel':
          return const Icon(
            Iconsax.routing,
            color: Colors.white,
            size: 100.0,
          );
        case 'Party':
          return const Icon(
            Icons.celebration_rounded,
            color: Colors.white,
            size: 100.0,
          );
        case 'Exam':
          return const Icon(
            Iconsax.teacher,
            color: Colors.white,
            size: 100.0,
          );
        case 'Reminder':
          return const Icon(
            Iconsax.notification_status,
            color: Colors.white,
            size: 100.0,
          );
        default:
          return const Icon(
            Iconsax.calendar_1,
            color: Colors.white,
            size: 100.0,
          );
      }
    }

    //main
    return Scaffold(
      backgroundColor: appColors.primaryColor,
      appBar: AppBar(
        backgroundColor: appColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          splashRadius: 20.0,
        ),
        title: Text(
          _title == '' ? '${widget.title} Event' : '$_title Event',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screen.width,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //icon displaying
              eventIcon(),
              const SizedBox(height: 30),
              //form
              Container(
                width: screen.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      key: const ValueKey('title'),
                      initialValue: widget.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      onChanged: (value) {
                        setState(() {
                          _title = value.trim();
                        });
                      },
                      maxLength: 25,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 1,
                    ),
                    TextFormField(
                      key: const ValueKey('note'),
                      initialValue: widget.notes,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      minLines: 1,
                      maxLines: 10,
                      onChanged: (value) {
                        setState(() {
                          _notes = value.trim();
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        hintText: 'Note',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),

              //Start picker
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Material(
                  color: Colors.white.withOpacity(.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showDialog(
                        CupertinoDatePicker(
                          minimumYear: 1800,
                          maximumYear: 2300,
                          initialDateTime: widget.startTime,
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
                              Text(
                                "Start Time",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: appColors.primaryColor),
                              ),
                              Text(
                                _startTime == null
                                    ? DateFormat('dd MMM')
                                        .add_jm()
                                        .format(widget.startTime)
                                    : DateFormat('dd MMM')
                                        .add_jm()
                                        .format(_startTime!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

              //Start picker
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Material(
                  color: Colors.white.withOpacity(.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showDialog(
                        CupertinoDatePicker(
                          minimumYear: 1800,
                          maximumYear: 2300,
                          initialDateTime: widget.endTime,
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
                              Text(
                                "End Time",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: appColors.primaryColor),
                              ),
                              Text(
                                _endTime == null
                                    ? DateFormat('dd MMM')
                                        .add_jm()
                                        .format(widget.endTime)
                                    : DateFormat('dd MMM')
                                        .add_jm()
                                        .format(_endTime!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

              //event type
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Material(
                  color: Colors.white.withOpacity(.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
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
                              Text(
                                "Event Type",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: appColors.primaryColor),
                              ),
                              Text(
                                _eventNames[_selectedEvent],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

              const SizedBox(height: 10),
              ((_title != '' && _title != widget.title) ||
                      (_notes != '' && _notes != widget.notes) ||
                      (_startTime != null && _startTime != widget.startTime) ||
                      (_endTime != null && _endTime != widget.endTime) ||
                      (_oldSelectedEvent != _selectedEvent))
                  ? BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
                      builder: (ctx1, state) {
                      return ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          //deleting exiting items
                          Provider.of<EventDataServices>(context, listen: false)
                              .deleteEvent(
                                  id: widget.id, filePath: state.filePath);
                          //adding new data into the list
                          updateEventList(state.filePath);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: appColors.primaryColor,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    })
                  : const TextButton(
                      onPressed: null,
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.transparent),
                      ),
                    ),

              const SizedBox(height: 30),
              //share button
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Material(
                  color: Colors.white.withOpacity(.8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    splashColor: appColors.primaryColor,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final box = context.findRenderObject() as RenderBox?;
                      final startTime =
                          DateFormat.yMMMEd().add_jm().format(widget.startTime);
                      final endTime =
                          DateFormat.yMMMEd().add_jm().format(widget.endTime);
                      String notes = '';
                      if (widget.notes != '') {
                        notes = '*${widget.notes}*';
                      }
                      String messageBody =
                          'FIND MY EVENT DETAILS\n\n💠Title: ${widget.title}\n\n💠Event Type: ${widget.eventType}\n\n💠From Time: $startTime\n\n💠End Time: $endTime\n\n💠Notes: $notes\n\n🤗🤗🤗🤗🤗🤗🤗🤗🤗🤗';

                      // subject is optional but it will be used
                      // only when sharing content over email
                      await Share.share(messageBody,
                          subject: "My Event",
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Share',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Icon(Icons.share_rounded, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //delete button
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Material(
                  color: appColors.redColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    splashColor: appColors.redColor.withOpacity(.3),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      showCupertinoModalPopup(
                          context: context,
                          builder: (ctx) {
                            return CupertinoActionSheet(
                              title: const Text(
                                "Are you sure you want to delete this event?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              actions: [
                                BlocBuilder<EventFileHandlerCubit,
                                    EventFileHandlerState>(
                                  builder: (context, state) {
                                    return CupertinoActionSheetAction(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: appColors.redColor,
                                        ),
                                      ),
                                      onPressed: () {
                                        NotificationService()
                                            .cancelNotification(
                                                id: widget.notificationId);
                                        //main
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).pop();
                                        Provider.of<EventDataServices>(context,
                                                listen: false)
                                            .deleteEvent(
                                                id: widget.id,
                                                filePath: state.filePath);
                                      },
                                    );
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                              ),
                            );
                          });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Icon(
                            Iconsax.minus_cirlce5,
                            color: Colors.white,
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
    );
  }

  void updateEventList(String filePath) {
    int notiID = widget.notificationId;
    //cancelling existing notification
    NotificationService().cancelNotification(id: notiID);
    String newId = widget.id,
        newTitle = widget.title,
        newNotes = widget.notes,
        newEventType = _eventNames[_selectedEvent];
    DateTime newStartTime = widget.startTime;
    DateTime newEndTime = widget.endTime;
    if (_startTime != null) {
      Random random = Random();
      notiID = random.nextInt(999999999) + 1000000000;
      newId = DateTime.now().toString();
      newStartTime = _startTime!;
    }
    if (_endTime != null) {
      newEndTime = _endTime!;
    }
    if (_title != '') {
      newTitle = _title;
    }
    if (_notes != '') {
      newNotes = _notes;
    }

    //adding new event
    Provider.of<EventDataServices>(context, listen: false).addNewEvent(
        id: newId,
        notificationId: notiID,
        title: newTitle,
        notes: newNotes,
        startTime: newStartTime,
        endTime: newEndTime,
        eventType: newEventType,
        fileExists: true,
        filePath: filePath,
        isSyncing: false,
        parentContext: context);

    String notiBody =
        'Notify Alert: Event of type $newEventType in 5 minutes.Check it out.';
    //adding new notification
    NotificationService().showNotification(
      id: notiID,
      title: newTitle,
      body: notiBody,
      dateTime: newStartTime,
    );
  }
}
