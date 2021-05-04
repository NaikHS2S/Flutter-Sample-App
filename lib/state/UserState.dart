import 'package:flutter_app/model/UserInfo.dart';

abstract class UserState{}

class InitState extends UserState {}
class Loading extends UserState {}
class Loaded extends UserState {
  final List<UserInfo> userInfoList;
  Loaded({this.userInfoList});
}
class UserListError extends UserState {
  final error;
  UserListError({this.error});
}