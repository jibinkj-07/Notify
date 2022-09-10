import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'date_state.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateInitial());

  bool isToday = false;
  final todayDate = DateTime.now();

  //date difference calculation function
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  void nextDay() {
    String day = "Tomorrow";
    final diff = calculateDifference(state.dateTime);
    if (diff == 1 || diff == -1) {
      day = 'Today';
    }
    emit(
      DateState(
          dateTime: state.dateTime.add(
            const Duration(days: 1),
          ),
          day: day),
    );
  }

  void prevDay() {
    String day = "Yesterday";
    final diff = calculateDifference(state.dateTime);
    if (diff == 1 || diff == -1) {
      day = 'Today';
    }
    emit(
      DateState(
          dateTime: state.dateTime.subtract(
            const Duration(days: 1),
          ),
          day: day),
    );
  }
}
