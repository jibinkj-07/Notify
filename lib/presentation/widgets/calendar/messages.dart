import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/services/firebase_services.dart';
import 'package:mynotify/presentation/widgets/calendar/message_body.dart';

class Messages extends StatelessWidget {
  const Messages({
    super.key,
    required this.username,
    required this.currentUserId,
    required this.sharedUserId,
    required this.gender,
  });
  final String username;
  final String currentUserId;
  final String sharedUserId;
  final String gender;
  @override
  Widget build(BuildContext context) {
    // AppColors appColors = AppColors();
    final screen = MediaQuery.of(context).size;
    final AppColors appColors = AppColors();

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

    //change the read status to false
    FirebaseFirestore.instance
        .collection('AllUserEvents')
        .doc(currentUserId)
        .collection('SharedCalendar')
        .doc(sharedUserId)
        .set({'read': true}, SetOptions(merge: true));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(.1),
        foregroundColor: appColors.primaryColor,
        toolbarHeight: 75,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashRadius: 20.0,
        ),
        title: Column(
          children: [
            SvgPicture.asset(
              'assets/images/illustrations/${gender}_avatar.svg',
              height: 40,
            ),
            Text(
              username,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          child: Text(
                            'Clear all',
                            style: TextStyle(
                              color: appColors.redColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            FirebaseServices().clearAllSharedCalendarViews(
                              currentUserId: currentUserId,
                              targetUserId: sharedUserId,
                            );
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                      ),
                    );
                  });
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors().primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SizedBox(
        width: screen.width,
        child: MessageBody(
          currentUserid: currentUserId,
          targetUserid: sharedUserId,
        ),
      )),
    );
  }

  // //widget for head
  // Widget messageHead(BuildContext context) => Container(
  //       color: Colors.blue,
  //       padding: const EdgeInsets.symmetric(vertical: 5),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           IconButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             icon: const Icon(Icons.arrow_back_ios_new_rounded),
  //             splashRadius: 20.0,
  //           ),
  //           Column(
  //             children: [
  //               SvgPicture.asset(
  //                 'assets/images/illustrations/${gender}_avatar.svg',
  //                 height: 40,
  //               ),
  //               Text(
  //                 username,
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               )
  //             ],
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Navigator.of(context).pop();
  //             },
  //             style: TextButton.styleFrom(
  //               foregroundColor: Colors.black,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             child: const Text(
  //               'Clear',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
}
