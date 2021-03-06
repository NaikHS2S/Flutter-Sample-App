import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/exceptions.dart';
import '../api/services.dart';
import '../model/user_info.dart';
import '../state/user_state.dart';
import '../events/user_events.dart';

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