import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState>
    with HydratedMixin {
  AuthenticationCubit() : super(AuthenticationInitial());

  //function for user not interested in cloud sync
  void loggingWithoutCloud() {
    emit(AuthenticationState(isNew: false, isCloudConnected: false));
  }

  //function for user with cloud sync
  void loggingWithCloud() {
    emit(AuthenticationState(isNew: false, isCloudConnected: true));
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    return AuthenticationState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    return state.toMap();
  }
}
