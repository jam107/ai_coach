import 'package:ai_coach/core/network/data_state.dart';
import 'package:ai_coach/core/usecase/usecase.dart';
import 'package:ai_coach/production/data/repositories/user_repository.dart';

class LogoutRequestUseCase implements UseCase<DataState, void> {
  final UserRepository _userRepository;

  LogoutRequestUseCase(this._userRepository);

  @override
  Future<DataState> call({void param}) async {
    DataState response = await _userRepository.logoutRequest();
    return response;
  }
}
