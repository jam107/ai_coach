import 'package:ai_coach/core/network/data_state.dart';
import 'package:ai_coach/production/domain/entities/user_entity.dart';

abstract class UserInterface<T extends UserEntity> {
  Future<DataState> createUser({required T user, required String password});
  Future<DataState> loginRequest({required T user, required String password});
  Future<DataState> logoutRequest();
  Future<DataState> getCurrentUser();
}
