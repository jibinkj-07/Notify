import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:mynotify/constants/app_colors.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //variables
    final screen = MediaQuery.of(context).size;

    //functions

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
                      const Text(
                        "New Event",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    ],
                  ),
                  //right portion
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors().primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  )
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
                      maxLength: 25,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
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
                      minLines: 1,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
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
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() -not to allow to choose before today.
                          lastDate: DateTime(2100));
                      print(pickedDate);
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
                                "01/Sep/2022",
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
                                  onPressed: () {},
                                  child: Text(
                                    'Birthday',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Travel',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Meeting',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Exam',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Alert',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors().primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
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
                                "Birthday",
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

              //remind me toggle
              Container(
                width: screen.width * .9,
                margin: const EdgeInsets.only(top: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Remind Me',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ToggleSwitch(
                      minWidth: 60.0,
                      minHeight: 30.0,
                      initialLabelIndex: 0,
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white54,
                      totalSwitches: 2,
                      labels: const [
                        'No',
                        'Yes',
                      ],

                      activeBgColors: [
                        [AppColors().redColor, Colors.red.withOpacity(.8)],
                        [AppColors().greenColor, Colors.green]
                      ],
                      animate:
                          true, // with just animate set to true, default curve = Curves.easeIn
                      curve: Curves
                          .easeInOut, // animate must be set to true when using custom curve
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ],
                ),
              )
              //end of main column
            ],
          ),
        ),
      ),
    );
  }
}
