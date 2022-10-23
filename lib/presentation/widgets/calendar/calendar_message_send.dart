import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';

class CalendarMessageSend extends StatefulWidget {
  const CalendarMessageSend({super.key, this.sharingDateTime});
  final DateTime? sharingDateTime;

  @override
  State<CalendarMessageSend> createState() => _CalendarMessageSendState();
}

class _CalendarMessageSendState extends State<CalendarMessageSend> {
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    final screen = MediaQuery.of(context).size;

    //datepicker pop up
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

    if (widget.sharingDateTime != null) {
      // ignore: unused_local_variable
      // final time = DateFormat.yM().format(widget.sharingDateTime);
    }
    return Scaffold(
      body: Center(
        child: Container(
          child: widget.sharingDateTime != null
              ? Text('Sharing ${widget.sharingDateTime.toString()}')
              : Text('No dateTime'),
        ),
      ),
    );
  }
}
