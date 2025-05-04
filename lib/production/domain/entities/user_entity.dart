import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String mail;
  final String username;
  final int studyDuration;
  final int hourPerDay;
  final List<Map<String, int>> busyHours;

  const UserEntity({
    this.mail = "",
    this.username = "",
    this.studyDuration = 0,
    this.hourPerDay = 0,
    this.busyHours = const <Map<String, int>>[],
  });

  @override
  List<Object?> get props => [mail, username];
}
