import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String mail;
  final String username;
  final List<Map<String, String>> tasks;
  final Map<String, String> weeklyAvailability;
  final Map<String, int> studySession;

  const UserEntity({
    this.mail = "",
    this.username = "",
    this.tasks = const [],
    this.weeklyAvailability = const {},
    this.studySession = const {},
  });

  @override
  List<Object?> get props => [mail, username];
}
