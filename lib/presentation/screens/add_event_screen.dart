import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
import 'package:mynotify/logic/services/event_data_services.dart';
import 'package:provider/provider.dart';
import 'package:mynotify/constants/app_colors.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _notes = '';
  String _title = '';
  DateTime _dateTime = DateTime.now();
  String _eventType = 'Birthday';

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

    //main
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //head part
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //left portion
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors().primaryColor,
                        ),
                        splashRadius: 20,
                      ),
                      Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors().primaryColor,
                        ),
                      )
                    ],
                  ),
                  //right portion
                  _title.trim() != ''
                      ? BlocBuilder<EventFileHandlerCubit,
                          EventFileHandlerState>(
                          builder: (ctx, state) {
                            if (state.isFileExists) {
                              return TextButton(
                                onPressed: () {
                                  Provider.of<EventDataServices>(context,
                                          listen: false)
                                      .addNewEvent(
                                    id: _dateTime.toString(),
                                    title: _title,
                                    notes: _notes,
                                    dateTime: _dateTime,
                                    eventType: _eventType,
                                    fileExists: true,
                                    parentContext: context,
                                    filePath: state.filePath,
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
                                  Provider.of<EventDataServices>(context,
                                          listen: false)
                                      .addNewEvent(
                                    id: _dateTime.toString(),
                                    title: _title,
                                    notes: _notes,
                                    dateTime: _dateTime,
                                    eventType: _eventType,
                                    parentContext: context,
                                    fileExists: false,
                                  );
                                  _titleController.clear();
                                  _notesController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Add",
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

              //form
              Container(
                width: screen.width * .9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: const EdgeInsets.symmetric(vertical: 20),
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

              //calender picker

              Container(
                width: screen.width * .9,
                margin: const EdgeInsets.only(top: 20),
                child: Material(
                  color: Colors.grey.withOpacity(.2),
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
                              const Text(
                                "Date",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat('dd MMM').add_jm().format(_dateTime),
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
                              const Text(
                                "Event Type",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _eventType,
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
    );
  }
}
