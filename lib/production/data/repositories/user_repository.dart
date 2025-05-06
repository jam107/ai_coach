import 'package:ai_coach/core/network/custom_response.dart';
import 'package:ai_coach/core/network/data_state.dart';
import 'package:ai_coach/production/data/data_sources/fb_api.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/domain/repo_interfaces/user_interface.dart';

class UserRepository extends UserInterface<UserModel> {
  FirebaseApi fbApi = FirebaseApi();
  @override
  Future<DataState> createUser(
      {required UserModel user, required String password}) async {
    CustomResponse response =
        await fbApi.createUser(user: user, password: password);
    if (response.status == true) {
      return DataSuccess(response.data);
    } else {
      return DataFailed(response.error!);
    }
  }

  @override
  Future<DataState> loginRequest(
      {required UserModel user, required String password}) async {
    CustomResponse response =
        await fbApi.signIn(user: user, password: password);
    if (response.status == true) {
      return DataSuccess(response.data);
    } else {
      return DataFailed(response.error!);
    }
  }

  @override
  Future<DataState> getCurrentUser() async {
    CustomResponse response = await fbApi.getCurrentUser();
    if (response.status == true) {
      return DataSuccess(response.data);
    } else {
      return DataFailed(response.error!);
    }
  }

  @override
  Future<DataState> logoutRequest() async {
    CustomResponse response = await fbApi.signOut();
    if (response.status == true) {
      return DataSuccess(response.data);
    } else {
      return DataFailed(response.error!);
    }
  }

  @override
  Future<DataState> updateUser({required UserModel updatedUser}) async {
    CustomResponse response = await fbApi.updateUser(updatedUser: updatedUser);
    if (response.status == true) {
      return DataSuccess(response.data);
    } else {
      return DataFailed(response.error!);
    }
  }
}
