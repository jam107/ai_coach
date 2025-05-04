import 'package:ai_coach/core/network/data_state.dart';
import 'package:ai_coach/core/usecase/usecase.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/data/repositories/user_repository.dart';

//also used for is authenticated
class GetCurrentUserUseCase implements UseCase<DataState, UserModel> {
  final UserRepository _userRepository;

  GetCurrentUserUseCase(this._userRepository);

  @override
  Future<DataState> call({void param}) async {
    DataState response = await _userRepository.getCurrentUser();
    return response;
  }
}
