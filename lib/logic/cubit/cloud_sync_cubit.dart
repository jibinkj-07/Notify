import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cloud_sync_state.dart';

class CloudSyncCubit extends Cubit<CloudSyncState> {
  CloudSyncCubit() : super(CloudSyncInitial());

  void cloudDataSynced() {
    emit(const CloudSyncState(isSynced: true));
  }
}
