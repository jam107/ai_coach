part of 'user_bloc_bloc.dart';

abstract class UserBlocEvent {
  final UserModel? user;
  final String? password;
  const UserBlocEvent({this.user, this.password});
}

class CreateUser extends UserBlocEvent {
  const CreateUser({required super.user, required super.password});
}

class LoginRequest extends UserBlocEvent {
  const LoginRequest({required super.user, required super.password});
}

class LogoutRequest extends UserBlocEvent {
  const LogoutRequest();
}

class GetCurrentUserRequest extends UserBlocEvent {
  const GetCurrentUserRequest();
}
