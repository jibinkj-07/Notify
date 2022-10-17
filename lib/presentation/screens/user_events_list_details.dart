// ignore_for_file: unnecessary_string_escapes

import 'dart:developer' as dlog;
import 'dart:math';

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
  final DateTime dateTime;
  const UserEventListDetails(
      {Key? key,
      required this.id,
      required this.notificationId,
      required this.title,
      required this.notes,
      required this.dateTime,
      required this.eventType})
      : super(key: key);

  @override
  State<UserEventListDetails> createState() => _UserEventListDetailsState();
}

class _UserEventListDetailsState extends State<UserEventListDetails> {
  String _notes = '';
  String _title = '';
  DateTime? _dateTime;
  String _eventType = '';

  @override
  Widget build(BuildContext context) {
    //variables
    final screen = MediaQuery.of(context).size;

//pick date and time function
    Future<DateTime?> pickDate() => showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

    Future<TimeOfDay?> pickTime() => showTimePicker(
          context: context,
          initialTime: TimeOfDay(
              hour: widget.dateTime.hour, minute: widget.dateTime.minute),
        );

    Future pickDateAndTime() async {
      FocusScope.of(context).unfocus();
      DateTime? dateTime = await pickDate();
      if (dateTime == null) return;

      TimeOfDay? time = await pickTime();
      if (time == null) return;

      final selectedDateTime = DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);

      setState(() {
        _dateTime = selectedDateTime;
      });
    }

    //event icon widget
    Widget eventIcon() {
      //Checking if user updated the eventtype or not
      if (_eventType != '') {
        switch (_eventType) {
          case 'Birthday':
            return const Icon(
              Iconsax.cake5,
              color: Colors.white,
              size: 100.0,
            );
          case 'Travel':
            return const Icon(
              Iconsax.routing,
              color: Colors.white,
              size: 100.0,
            );
          case 'Meeting':
            return const Icon(
              Iconsax.brifecase_timer5,
              color: Colors.white,
              size: 100.0,
            );
          case 'Work':
            return const Icon(
              Iconsax.buildings5,
              color: Colors.white,
              size: 100.0,
            );
          case 'Exam':
            return const Icon(
              Iconsax.menu_board5,
              color: Colors.white,
              size: 100.0,
            );
          case 'Reminder':
            return const Icon(
              Iconsax.notification5,
              color: Colors.white,
              size: 100.0,
            );
          case 'Others':
            return const Icon(
              Iconsax.calendar_25,
              color: Colors.white,
              size: 100.0,
            );
        }
      }
      //Icon choosing depends on eventtype
      switch (widget.eventType) {
        case 'Birthday':
          return const Icon(
            Iconsax.cake5,
            color: Colors.white,
            size: 100.0,
          );
        case 'Travel':
          return const Icon(
            Iconsax.routing,
            color: Colors.white,
            size: 100.0,
          );
        case 'Meeting':
          return const Icon(
            Iconsax.brifecase_timer5,
            color: Colors.white,
            size: 100.0,
          );
        case 'Work':
          return const Icon(
            Iconsax.buildings5,
            color: Colors.white,
            size: 100.0,
          );
        case 'Exam':
          return const Icon(
            Iconsax.menu_board5,
            color: Colors.white,
            size: 100.0,
          );
        case 'Reminder':
          return const Icon(
            Iconsax.notification5,
            color: Colors.white,
            size: 100.0,
          );
        case 'Others':
          return const Icon(
            Iconsax.calendar_25,
            color: Colors.white,
            size: 100.0,
          );
        default:
          return const Icon(
            Iconsax.calendar5,
            color: Colors.white,
            size: 100.0,
          );
      }
    }

    //main
    return Scaffold(
      backgroundColor: AppColors().primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors().primaryColor,
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
        titleSpacing: 1.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
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

              //calender picker

              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Material(
                  color: Colors.white.withOpacity(.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () async {
                      pickDateAndTime();
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
                                "Date",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors().primaryColor),
                              ),
                              Text(
                                _dateTime == null
                                    ? DateFormat('dd MMM')
                                        .add_jm()
                                        .format(widget.dateTime)
                                    : DateFormat('dd MMM')
                                        .add_jm()
                                        .format(_dateTime!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                      showModalBottomSheet(
                        context: context,
                        //elevates modal bottom screen
                        elevation: 20,
                        // gives rounded corner to modal bottom screen
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        builder: (ctx) {
                          return SizedBox(
                            // height: screen.height * .35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //buttons
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _eventType = 'Birthday';
                                    });
                                  },
                                  child: Text(
                                    'Birthday',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _eventType = 'Travel';
                                    });
                                  },
                                  child: Text(
                                    'Travel',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _eventType = 'Meeting';
                                    });
                                  },
                                  child: Text(
                                    'Meeting',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _eventType = 'Work';
                                    });
                                  },
                                  child: Text(
                                    'Work',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _eventType = 'Exam';
                                    });
                                  },
                                  child: Text(
                                    'Exam',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _eventType = 'Reminder';
                                    });
                                  },
                                  child: Text(
                                    'Reminder',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _eventType = 'Others';
                                    });
                                  },
                                  child: Text(
                                    'Others',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
                                    color: AppColors().primaryColor),
                              ),
                              Text(
                                _eventType == ''
                                    ? widget.eventType
                                    : _eventType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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

              const SizedBox(height: 10),
              ((_title != '' && _title != widget.title) ||
                      (_notes != '' && _notes != widget.notes) ||
                      (_dateTime != null && _dateTime != widget.dateTime) ||
                      (_eventType != '' && _eventType != widget.eventType))
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
                          primary: Colors.white,
                          onPrimary: AppColors().primaryColor,
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
                    splashColor: AppColors().primaryColor,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final box = context.findRenderObject() as RenderBox?;
                      final time =
                          DateFormat.yMMMEd().add_jm().format(widget.dateTime);
                      String notes = '';
                      if (widget.notes != '') {
                        notes = '*${widget.notes}*';
                      }
                      String messageBody =
                          '*FIND MY EVENT DETAILS*\n\n💠Date: *$time*\n\n💠Title: *${widget.title}*\n\n💠Event Type: *${widget.eventType}*\n\n💠Notes: $notes\n🤗🤗🤗🤗🤗🤗🤗🤗🤗🤗';

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
                  color: AppColors().redColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    splashColor: AppColors().redColor.withOpacity(.3),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          //elevates modal bottom screen
                          elevation: 0,
                          // gives rounded corner to modal bottom screen
                          // shape: const RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(30),
                          //     topRight: Radius.circular(30),
                          //   ),
                          // ),
                          builder: (ctx) {
                            return Container(
                              width: screen.width,
                              height: screen.height * .20,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //DELETE BUTTON
                                  Container(
                                    height: screen.height * .12,
                                    padding: const EdgeInsets.only(top: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Are you sure you want to delete this event?',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        const Divider(height: 0, thickness: 1),
                                        SizedBox(
                                          height: screen.height * .065,
                                          width: screen.width,
                                          child: BlocBuilder<
                                              EventFileHandlerCubit,
                                              EventFileHandlerState>(
                                            builder: (ctx1, state) {
                                              return ElevatedButton(
                                                onPressed: () {
                                                  NotificationService()
                                                      .cancelNotification(
                                                          id: widget
                                                              .notificationId);
                                                  //main
                                                  Navigator.of(ctx).pop();
                                                  Navigator.of(context).pop();
                                                  Provider.of<EventDataServices>(
                                                          context,
                                                          listen: false)
                                                      .deleteEvent(
                                                          id: widget.id,
                                                          filePath:
                                                              state.filePath);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary:
                                                      AppColors().redColor,
                                                  elevation: 0,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: AppColors().redColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //CANCEL BUTTON
                                  SizedBox(
                                    height: screen.height * .065,
                                    width: screen.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white.withOpacity(.9),
                                        onPrimary: AppColors()
                                            .primaryColor
                                            .withOpacity(.3),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: AppColors().primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
        newEventType = widget.eventType;
    DateTime newDateTime = widget.dateTime;
    if (_dateTime != null) {
      Random random = Random();
      notiID = random.nextInt(999999999) + 1000000000;
      newId = DateTime.now().toString();
      newDateTime = _dateTime!;
    }
    if (_title != '') {
      newTitle = _title;
    }
    if (_notes != '') {
      newNotes = _notes;
    }
    if (_eventType != '') {
      newEventType = _eventType;
    }

    //adding new event
    Provider.of<EventDataServices>(context, listen: false).addNewEvent(
        id: newId,
        notificationId: notiID,
        title: newTitle,
        notes: newNotes,
        dateTime: newDateTime,
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
      dateTime: newDateTime,
    );
  }
}
