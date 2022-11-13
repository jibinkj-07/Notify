// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventListModel {
  final String id;
  final int notificationId;
  final String title;
  final String notes;
  final DateTime startTime;
  final DateTime endTime;
  final String eventDate;
  final String eventType;

  const EventListModel({
    required this.id,
    required this.notificationId,
    required this.title,
    required this.notes,
    required this.startTime,
    required this.endTime,
    required this.eventDate,
    required this.eventType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'notificationId': notificationId,
      'title': title,
      'notes': notes,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'eventDate': eventDate,
      'eventType': eventType,
    };
  }

  factory EventListModel.fromMap(Map<String, dynamic> map) {
    return EventListModel(
      id: map['id'] as String,
      notificationId: map['notificationId'] as int,
      title: map['title'] as String,
      notes: map['notes'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      eventDate: map['eventDate'] as String,
      eventType: map['eventType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventListModel.fromJson(String source) =>
      EventListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
