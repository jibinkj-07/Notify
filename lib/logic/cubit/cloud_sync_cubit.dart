import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'cloud_sync_state.dart';

class CloudSyncCubit extends Cubit<CloudSyncState> with HydratedMixin {
  CloudSyncCubit() : super(CloudSyncInitial());

  void cloudDataSynced() {
    emit(const CloudSyncState(isSynced: true, hasData: false));
  }

  void cloudHasData() {
    emit(const CloudSyncState(isSynced: false, hasData: true));
  }

  void cloudHasNoData() {
    emit(const CloudSyncState(isSynced: false, hasData: false));
  }

  @override
  CloudSyncState? fromJson(Map<String, dynamic> json) {
    return CloudSyncState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(CloudSyncState state) {
    return state.toMap();
  }
}
