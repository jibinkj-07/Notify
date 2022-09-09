import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mynotify/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors().primaryColor,
                    ),
                    splashRadius: 20,
                  ),
                  const Text(
                    'Today',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors().primaryColor,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '07 September 2022',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors().primaryColor),
                  ),
                  Icon(
                    // Iconsax.cloud,
                    // color: AppColors().primaryColor,
                    Iconsax.cloud_cross,
                    color: AppColors().redColor,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                // child: Center(
                //     child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Icon(
                //       Iconsax.note_text,
                //       color: AppColors().primaryColor,
                //       size: 50,
                //     ),
                //     Text(
                //       "No Events",
                //       style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.w700,
                //           color: AppColors().primaryColor),
                //     )
                //   ],
                // )),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors().primaryColor,
                          AppColors().primaryColor.withOpacity(.6),
                          Colors.white.withOpacity(.5),
                          Colors.white
                        ],
                      ),
                    ),
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return const ListViewItem();
                      },
                      itemCount: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: TextButton.icon(
          onPressed: () {},
          icon: Icon(
            Iconsax.add_circle,
            color: AppColors().primaryColor,
          ),
          label: Text(
            'Add Event',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors().primaryColor),
          )),
    );
  }
}

class ListViewItem extends StatelessWidget {
  const ListViewItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors().greenColor),
          ),
          const SizedBox(height: 10),
          const Text(
            "Title",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          Text(
            'notes',
            style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(.5),
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
