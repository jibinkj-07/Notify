import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/presentation/widgets/calendar/calendar_message_list_item.dart';

class CalendarMessageScreen extends StatelessWidget {
  const CalendarMessageScreen({
    super.key,
  });

  //main
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    final screen = MediaQuery.of(context).size;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    log('user id is $currentUserId');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text(
          'Shared Calendar',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: screen.width,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // //choosing sent or inbox option
            // CupertinoSegmentedControl(
            //     borderColor: appColors.primaryColor,
            //     selectedColor: appColors.primaryColor,
            //     children: const {
            //       'inbox': Text(
            //         "Inbox",
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //       'sent': Text(
            //         "Sent",
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       )
            //     },
            //     groupValue: pageOption,
            //     onValueChanged: (value) {
            //       setState(() {
            //         pageOption = value.toString();
            //       });
            //     }),

            //MAIN BODY PART

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AllUserEvents')
                  .doc(currentUserId.trim().toString())
                  .collection('SharedCalendar')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: appColors.primaryColor,
                      ),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  // log('legnth is ${snapshot.data!.docs.toString()}');
                  if (snapshot.data!.docs.isEmpty) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/illustrations/no_events.svg',
                            height: 100,
                          ),
                          const Text(
                            "No shared calendar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx1, i) {
                          DateTime date =
                              snapshot.data!.docs[i].get('time').toDate();

                          return CalendarMessageListItem(
                              date: date,
                              currentUserId: currentUserId,
                              sharedUserId: snapshot.data!.docs[i].id);
                        }),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
