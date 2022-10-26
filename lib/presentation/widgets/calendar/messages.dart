import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/presentation/widgets/calendar/message_body.dart';
import 'package:mynotify/presentation/widgets/calendar/message_item.dart';

class Messages extends StatelessWidget {
  const Messages({
    super.key,
    required this.username,
    required this.currentUserId,
    required this.sharedUserId,
  });
  final String username;
  final String currentUserId;
  final String sharedUserId;
  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        width: screen.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            //head portion
            messageHead(context),
            const SizedBox(height: 8),
            //chat list view section
            Expanded(
                child: MessageBody(
              currentUserid: currentUserId,
              targetUserid: sharedUserId,
            )),
          ],
        ),
      )),
    );
  }

  //widget for head
  Widget messageHead(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            splashRadius: 20.0,
          ),
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/illustrations/male_avatar.svg',
                height: 40,
              ),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
}
