import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mynotify/constants/app_colors.dart';
import 'package:mynotify/logic/cubit/event_file_handler_cubit.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  //init
  Future<void> initializePlatformNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/noti_icon');

    const InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notifications.initialize(
      settings,
    );
  }

  Future<NotificationDetails> _notificationDetails(
      {required String eventType}) async {
    final largeIcon = eventType.toLowerCase();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'userEvent001',
      'User Events',
      groupKey: 'com.example.mynotify',
      channelDescription: 'Notifications for user created events',
      importance: Importance.high,
      priority: Priority.high,
      sound: const RawResourceAndroidNotificationSound('notification'),
      color: AppColors().primaryColor,
      largeIcon: DrawableResourceAndroidBitmap(largeIcon),
      // styleInformation: BigPictureStyleInformation(
      //   FilePathAndroidBitmap(bigPicture),
      //   hideExpandedLargeIcon: false,
      // ),
      playSound: true,
    );
    return NotificationDetails(android: androidNotificationDetails);
  }

  //showing notificaion function
  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      required String eventType,
      required DateTime dateTime}) async {
    final detail = await _notificationDetails(eventType: eventType);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime.from(
      //     dateTime.subtract(
      //       const Duration(minutes: 1),
      //     ),
      //     tz.local),
      tz.TZDateTime.from(
          dateTime.subtract(
            const Duration(minutes: 5),
          ),
          tz.local),
      detail,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
