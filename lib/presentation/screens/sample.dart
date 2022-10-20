import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker.
    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ));
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('Time is $_selectedDate'),
              TextButton(
                onPressed: () {
                  _showDialog(
                    CupertinoDatePicker(
                      minimumYear: 1800,
                      maximumYear: 2300,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (value) {
                        setState(() {
                          _selectedDate = value;
                        });
                      },
                    ),
                  );
                },
                child: const Text('Pick Date'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
