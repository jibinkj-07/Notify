part of 'date_cubit.dart';

class DateState {
  final DateTime dateTime;
  final String day;
  DateState({required this.dateTime, required this.day});
}

class DateInitial extends DateState {
  DateInitial() : super(dateTime: DateTime.now(), day: 'Today');
}
