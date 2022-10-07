// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cloud_sync_cubit.dart';

class CloudSyncState {
  final bool isSynced;
  final bool hasData;
  const CloudSyncState({required this.isSynced,required this.hasData});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isSynced': isSynced,
      'hasData':hasData,
    };
  }

  factory CloudSyncState.fromMap(Map<String, dynamic> map) {
    return CloudSyncState(
      isSynced: map['isSynced'] as bool,
      hasData: map['hasData'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CloudSyncState.fromJson(String source) =>
      CloudSyncState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CloudSyncInitial extends CloudSyncState {
  CloudSyncInitial() : super(isSynced: false,hasData: false);
}
