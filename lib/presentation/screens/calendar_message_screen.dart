import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import '../widgets/calendar/calendar_message_send.dart';
import '../widgets/calendar/date_picker.dart' as DatePicker;

class CalendarMessageScreen extends StatelessWidget {
  const CalendarMessageScreen({super.key});

  //main
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    //no shared event widget
    var noSharedEvents = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Iconsax.directbox_notif,
          color: appColors.primaryColor,
          size: 50,
        ),
        Text(
          "No Shared Events",
          style: TextStyle(
            fontSize: 18,
            color: appColors.primaryColor,
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: appColors.primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text(
          'Event Box',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(child: noSharedEvents),
      floatingActionButton: FloatingActionButton(
          backgroundColor: appColors.primaryColor,
          onPressed: () {
            //opeing datepicker
            // showDialog(
            //   DatePicker.CupertinoDatePicker(
            //     mode: DatePicker.CupertinoDatePickerMode.date,
            //     minimumYear: 1800,
            //     maximumYear: 2300,
            //     initialDateTime: DateTime.now(),
            //     onDateTimeChanged: (value) {
            //       setState(() {
            //         _choosenDateTime = value;
            //       });
            //     },
            //   ),
            // );

            Navigator.push(
              context,
              PageTransition(
                reverseDuration: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 300),
                type: PageTransitionType.fade,
                child: const CalendarMessageSend(),
              ),
            );
          },
          child: const Icon(Iconsax.sms_edit)),
    );
  }
}
