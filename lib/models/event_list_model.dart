// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EventListModel extends Equatable {
  final String title;
  final String notes;
  final DateTime dateTime;
  final String eventType;
  final bool alertMe;
  const EventListModel({
    required this.title,
    required this.notes,
    required this.dateTime,
    required this.eventType,
    required this.alertMe,
  });

  EventListModel copyWith({
    String? title,
    String? notes,
    DateTime? dateTime,
    String? eventType,
    bool? alertMe,
  }) {
    return EventListModel(
      title: title ?? this.title,
      notes: notes ?? this.notes,
      dateTime: dateTime ?? this.dateTime,
      eventType: eventType ?? this.eventType,
      alertMe: alertMe ?? this.alertMe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'notes': notes,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'eventType': eventType,
      'alertMe': alertMe,
    };
  }

  factory EventListModel.fromMap(Map<String, dynamic> map) {
    return EventListModel(
      title: map['title'] as String,
      notes: map['notes'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      eventType: map['eventType'] as String,
      alertMe: map['alertMe'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        title,
        notes,
        dateTime,
        eventType,
        alertMe,
      ];
}
