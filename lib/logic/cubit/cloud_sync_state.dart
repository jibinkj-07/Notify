part of 'cloud_sync_cubit.dart';

class CloudSyncState {
  final bool isSynced;
  const CloudSyncState({required this.isSynced});
}

class CloudSyncInitial extends CloudSyncState {
  CloudSyncInitial() : super(isSynced: false);
}
