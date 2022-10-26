// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'authentication_cubit.dart';

class AuthenticationState {
  final bool isNew;
  final bool isCloudConnected;
  final String gender;
  AuthenticationState({
    required this.isNew,
    required this.isCloudConnected,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isNew': isNew,
      'isCloudConnected': isCloudConnected,
      'gender': gender,
    };
  }

  factory AuthenticationState.fromMap(Map<String, dynamic> map) {
    return AuthenticationState(
      isNew: map['isNew'] as bool,
      isCloudConnected: map['isCloudConnected'] as bool,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationState.fromJson(String source) =>
      AuthenticationState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AuthenticationInitial extends AuthenticationState {
  AuthenticationInitial()
      : super(isNew: true, isCloudConnected: false, gender: 'male');
}
