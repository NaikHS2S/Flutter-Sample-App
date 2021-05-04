import 'dart:io';
import 'package:flutter_app/api/Exceptions.dart';
import 'package:flutter_app/api/Services.dart';
import 'package:flutter_app/model/UserInfo.dart';
import 'package:flutter_app/state/UserState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/UserInfoEvents.dart';

class UserBloc extends Bloc<UserInfoEvents, UserState> {
  NetworkRepo networkRepo = UserServices();
  List<UserInfo> userList;

  UserBloc() : super(InitState());

  @override
  Stream<UserState> mapEventToState(UserInfoEvents event) async* {
    switch (event) {
      case UserInfoEvents.fetchUser:
        yield Loading();
        try {
          userList = await networkRepo.getUserList().timeout(const Duration(milliseconds: 3000));
          yield Loaded(userInfoList: userList);
        } on SocketException {
          yield UserListError(
            error: NoInternetException('No Internet'),
          );
        } on HttpException {
          yield UserListError(
            error: NoServiceFoundException('No Service Found'),
          );
        } on FormatException {
          yield UserListError(
            error: InvalidFormatException('Invalid Response format'),
          );
        } catch (e) {
          yield UserListError(
            error: UnknownException('Unknown Error'),
          );
        }
        break;
    }
  }
}