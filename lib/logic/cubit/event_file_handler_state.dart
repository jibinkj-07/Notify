// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'event_file_handler_cubit.dart';

class EventFileHandlerState extends Equatable {
  final bool isFileExists;
  final String filePath;
  const EventFileHandlerState(
      {required this.isFileExists, required this.filePath});

  @override
  List<Object> get props => [];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isFileExists': isFileExists,
      'filePath': filePath,
    };
  }

  factory EventFileHandlerState.fromMap(Map<String, dynamic> map) {
    return EventFileHandlerState(
      isFileExists: map['isFileExists'] as bool,
      filePath: map['filePath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventFileHandlerState.fromJson(String source) =>
      EventFileHandlerState.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class EventFileHandlerInitial extends EventFileHandlerState {
  const EventFileHandlerInitial() : super(isFileExists: false, filePath: '');
}
