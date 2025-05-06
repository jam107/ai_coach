import 'package:ai_coach/core/network/data_state.dart';
import 'package:ai_coach/production/data/models/user_model.dart';
import 'package:ai_coach/production/data/repositories/user_repository.dart';
import 'package:ai_coach/production/domain/use_cases/create_user.dart';
import 'package:ai_coach/production/domain/use_cases/get_current_user.dart';
import 'package:ai_coach/production/domain/use_cases/login_request.dart';
import 'package:ai_coach/production/domain/use_cases/logout_request.dart';
import 'package:ai_coach/production/domain/use_cases/update_user.dart';
import 'package:bloc/bloc.dart';

part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBlocBloc extends Bloc<UserBlocEvent, UserBlocState> {
  final UserRepository _userRepository = UserRepository();

  late CreteUserUseCase _createUserUseCase;
  late LoginRequestUseCase _loginRequestUseCase;
  late LogoutRequestUseCase _logoutRequestUseCase;
  late GetCurrentUserUseCase _getCurrentUserUseCase;
  late UpdateUserUseCase _updateUserUseCase;

  UserBlocBloc() : super(const UserBlocInitial()) {
    _createUserUseCase = CreteUserUseCase(_userRepository);
    _loginRequestUseCase = LoginRequestUseCase(_userRepository);
    _logoutRequestUseCase = LogoutRequestUseCase(_userRepository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(_userRepository);
    _updateUserUseCase = UpdateUserUseCase(_userRepository);

    on<CreateUser>(onCreateUser);
    on<LoginRequest>(onLoginRequest);
    on<LogoutRequest>(onLogoutRequest);
    on<GetCurrentUserRequest>(onGetCurrentUserRequest);
    on<UpdateUserRequest>(onUpdateUserRequest);
  }

  void onGetCurrentUserRequest(
      GetCurrentUserRequest event, Emitter<UserBlocState> emit) async {
    emit(const IsAuthenticatedLoading());
    final DataState dataState = await _getCurrentUserUseCase.call();
    if (dataState is DataSuccess && dataState.data != null) {
      emit(IsAuthenticatedDone(data: dataState.data!));
    } else {
      emit(IsAuthenticatedError(error: dataState.error));
    }
  }

  void onCreateUser(CreateUser event, Emitter<UserBlocState> emit) async {
    emit(const UserBlocLoading());
    final DataState dataState = await _createUserUseCase.call(
        param1: event.user!, param2: event.password!);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(UserBlocDone(data: dataState.data!));
    } else {
      emit(UserBlocError(error: dataState.error));
    }
  }

  void onLoginRequest(LoginRequest event, Emitter<UserBlocState> emit) async {
    emit(const UserBlocLoading());
    final DataState dataState = await _loginRequestUseCase.call(
        param1: event.user!, param2: event.password!);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(UserBlocDone(data: dataState.data!));
    } else {
      emit(UserBlocError(error: dataState.error));
    }
  }

  void onLogoutRequest(LogoutRequest event, Emitter<UserBlocState> emit) async {
    emit(const UserBlocLoading());
    final DataState dataState = await _logoutRequestUseCase.call();
    if (dataState is DataSuccess && dataState.data != null) {
      emit(UserBlocLogout(data: dataState.data!));
    } else {
      emit(UserBlocError(error: dataState.error));
    }
  }

  void onUpdateUserRequest(
      UpdateUserRequest event, Emitter<UserBlocState> emit) async {
    emit(const UserUpdateLoading());
    final DataState dataState =
        await _updateUserUseCase.call(param: event.user!);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(UserUpdateDone(data: dataState.data!));
    } else {
      emit(UserUpdateError(error: dataState.error));
    }
  }
}
