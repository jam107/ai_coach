import 'package:ai_coach/core/network/data_state.dart';
import 'package:ai_coach/core/usecase/usecase.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/data/repositories/user_repository.dart';

class UpdateUserUseCase implements UseCase<DataState, UserModel> {
  final UserRepository _userRepository;

  UpdateUserUseCase(this._userRepository);

  @override
  Future<DataState> call({required UserModel param}) async {
    DataState response = await _userRepository.updateUser(updatedUser: param);
    return response;
  }
}
