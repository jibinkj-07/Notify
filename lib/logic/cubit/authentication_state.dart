// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'authentication_cubit.dart';

class AuthenticationState {
  final bool isNew;
  final bool isCloudConnected;
  AuthenticationState({required this.isNew, required this.isCloudConnected});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isNew': isNew,
      'isCloudConnected': isCloudConnected,
    };
  }

  factory AuthenticationState.fromMap(Map<String, dynamic> map) {
    return AuthenticationState(
      isNew: map['isNew'] as bool,
      isCloudConnected: map['isCloudConnected'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationState.fromJson(String source) =>
      AuthenticationState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AuthenticationInitial extends AuthenticationState {
  AuthenticationInitial() : super(isNew: true, isCloudConnected: false);
}
