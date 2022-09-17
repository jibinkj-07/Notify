// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventListModel {
  final String id;
  final String title;
  final String notes;
  final DateTime dateTime;
  final String eventType;
  final bool alertMe;
  const EventListModel({
    required this.id,
    required this.title,
    required this.notes,
    required this.dateTime,
    required this.eventType,
    required this.alertMe,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'notes': notes,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'eventType': eventType,
      'alertMe': alertMe,
    };
  }

  factory EventListModel.fromMap(Map<String, dynamic> map) {
    return EventListModel(
      id: map['id'] as String,
      title: map['title'] as String,
      notes: map['notes'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      eventType: map['eventType'] as String,
      alertMe: map['alertMe'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventListModel.fromJson(String source) =>
      EventListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
