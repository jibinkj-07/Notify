// ignore_for_file: unnecessary_string_escapes

import 'dart:developer' as dlog;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:mynotify/logic/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../logic/cubit/event_file_handler_cubit.dart';

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

  final List<String> eventNames = <String>[
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
    _oldSelectedEvent = eventNames.indexOf(widget.eventType);
    _selectedEvent = eventNames.indexOf(widget.eventType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //variables
    final screen = MediaQuery.of(context).size;
    AppColors appColors = AppColors();
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors().primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //share button
                    IconButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final box = context.findRenderObject() as RenderBox?;
                        final startTime = DateFormat.yMMMEd()
                            .add_jm()
                            .format(widget.startTime);
                        final endTime =
                            DateFormat.yMMMEd().add_jm().format(widget.endTime);

                        String messageBody =
                            'FIND MY EVENT DETAILS\n\n💠Title: ${widget.title}\n\n💠Event Type: ${widget.eventType}\n\n💠From Time: $startTime\n\n💠End Time: $endTime\n\n💠Notes: ${widget.notes}\n\n🤗🤗🤗🤗🤗🤗🤗🤗🤗🤗';

                        // subject is optional but it will be used
                        // only when sharing content over email
                        await Share.share(messageBody,
                            subject: "My Event",
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size);
                      },
                      icon: const Icon(Icons.share),
                      color: appColors.primaryColor,
                      splashRadius: 20.0,
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
                            height: 250,
                          ),
                          const SizedBox(height: 8.0),
                          //title section
                          Container(
                            width: screen.width * .9,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: appColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              key: const ValueKey('title'),
                              initialValue: widget.title,
                              onChanged: (value) {
                                setState(() {
                                  _title = value.trim();
                                });
                              },
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              cursorColor: Colors.white,
                              maxLength: 25,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                hintText: 'Title',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(.35),
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
                                  color:
                                      appColors.primaryColor.withOpacity(.15),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextFormField(
                                  key: const ValueKey('note'),
                                  initialValue: widget.notes,
                                  minLines: 4,
                                  maxLines: 10,
                                  onChanged: (value) {
                                    setState(() {
                                      _notes = value.trim();
                                    });
                                  },
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: appColors.primaryColor,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    hintText: 'eg: Most awaited moment....',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          //start time section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Time",
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
                                  color:
                                      appColors.primaryColor.withOpacity(.15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          splashColor: appColors.primaryColor,
                                          highlightColor: appColors.primaryColor
                                              .withOpacity(.3),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            showDialog(
                                              CupertinoDatePicker(
                                                minimumYear: 1800,
                                                maximumYear: 2300,
                                                initialDateTime:
                                                    widget.startTime,
                                                onDateTimeChanged: (value) {
                                                  setState(() {
                                                    _startTime = value;
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                          child: Text(
                                            _startTime == null
                                                ? DateFormat('dd MMM')
                                                    .add_jm()
                                                    .format(widget.startTime)
                                                : DateFormat('dd MMM')
                                                    .add_jm()
                                                    .format(_startTime!),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: appColors.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        const Text(
                                          'to',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        //end time
                                        InkWell(
                                          splashColor: appColors.primaryColor,
                                          highlightColor: appColors.primaryColor
                                              .withOpacity(.3),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            showDialog(
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
                                          child: Text(
                                            _endTime == null
                                                ? DateFormat('dd MMM')
                                                    .add_jm()
                                                    .format(widget.endTime)
                                                : DateFormat('dd MMM')
                                                    .add_jm()
                                                    .format(_endTime!),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: appColors.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),
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
                                  color:
                                      appColors.primaryColor.withOpacity(.15),
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
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: appColors.primaryColor),
                                          ),
                                          Icon(
                                            Iconsax.edit_25,
                                            size: 20,
                                            color: AppColors().primaryColor,
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
              //update button
              ((_title != '' && _title != widget.title) ||
                      (_notes != '' && _notes != widget.notes) ||
                      (_startTime != null && _startTime != widget.startTime) ||
                      (_endTime != null && _endTime != widget.endTime) ||
                      (_oldSelectedEvent != _selectedEvent))
                  ? BlocBuilder<EventFileHandlerCubit, EventFileHandlerState>(
                      builder: (ctx1, state) {
                      return SizedBox(
                        width: screen.width * .9,
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            //deleting exiting items
                            Provider.of<EventDataServices>(context,
                                    listen: false)
                                .deleteEvent(
                                    id: widget.id, filePath: state.filePath);
                            //adding new data into the list
                            updateEventList(state.filePath);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(.3),
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    })
                  : const SizedBox(),

              //delete button
              SizedBox(
                width: screen.width * .9,
                child: ElevatedButton(
                  onPressed: () async {
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
                                      NotificationService().cancelNotification(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.redColor,
                    disabledBackgroundColor:
                        AppColors().primaryColor.withOpacity(.2),
                    disabledForegroundColor:
                        AppColors().primaryColor.withOpacity(.4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
        newEventType = eventNames[_selectedEvent];
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
