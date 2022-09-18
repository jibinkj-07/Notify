import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'event_file_handler_state.dart';

class EventFileHandlerCubit extends Cubit<EventFileHandlerState>
    with HydratedMixin {
  EventFileHandlerCubit() : super(const EventFileHandlerInitial());

  //file exists
  void fileExists({required String filePath}) {
    emit(EventFileHandlerState(isFileExists: true, filePath: filePath));
  }

  //file does not exists
  void fileNotExists() {
    emit(const EventFileHandlerState(isFileExists: false, filePath: ''));
  }

  @override
  EventFileHandlerState? fromJson(Map<String, dynamic> json) {
    return EventFileHandlerState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(EventFileHandlerState state) {
    return state.toMap();
  }
}
