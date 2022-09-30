import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/constants/app_colors.dart';

class UserEventListDetails extends StatefulWidget {
  final String id, title, notes, eventType;
  final DateTime dateTime;
  const UserEventListDetails(
      {Key? key,
      required this.id,
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
          initialTime: TimeOfDay.now(),
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
          case 'Exam':
            return const Icon(
              Iconsax.menu_board5,
              color: Colors.white,
              size: 100.0,
            );
          case 'Alert':
            return const Icon(
              Iconsax.alarm5,
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
      } else {}
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
        case 'Exam':
          return const Icon(
            Iconsax.menu_board5,
            color: Colors.white,
            size: 100.0,
          );
        case 'Alert':
          return const Icon(
            Iconsax.alarm5,
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
          ;
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
          margin: const EdgeInsets.only(top: 20),
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
                            height: screen.height * .35,
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
                                      _eventType = 'Alert';
                                    });
                                  },
                                  child: Text(
                                    'Alert',
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

              //BOTTOM BUTTONS

              //update button
              // if (_title != '' && _title != widget.title)
              // Material(
              //   // color: AppColors().primaryColor.withOpacity(.15),
              //   color: Colors.grey.withOpacity(.2),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10)),
              //   child: InkWell(
              //     splashColor: AppColors().primaryColor.withOpacity(.3),
              //     onTap: () async {
              //       // pickDateAndTime();
              //     },
              //     borderRadius: BorderRadius.circular(10),
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 20, vertical: 10),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Update',
              //             style: TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.bold,
              //                 color: AppColors().primaryColor),
              //           ),
              //           Icon(
              //             Iconsax.edit,
              //             color: AppColors().primaryColor,
              //             size: 20.0,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              ((_title != '' && _title != widget.title) ||
                      (_notes != '' && _notes != widget.notes) ||
                      (_dateTime != null && _dateTime != widget.dateTime) ||
                      (_eventType != '' && _eventType != widget.eventType))
                  ? ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
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
                    )
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
              //delete button
              const SizedBox(height: 30),
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
                              height: screen.width * .35,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Delete the event ${widget.title}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    AppColors().primaryColor),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          style: TextButton.styleFrom(
                                            primary: AppColors().redColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors().redColor),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
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
}
