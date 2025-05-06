import 'package:ai_coach/production/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.mail,
    super.username,
    super.tasks,
    super.weeklyAvailability,
    super.studySession,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        mail: json['mail'] as String,
        username: json['username'] as String,
        tasks: (json['tasks'] as List<dynamic>)
            .map((e) => Map<String, String>.from(e as Map))
            .toList(),
        weeklyAvailability:
            Map<String, String>.from(json['weeklyAvailability']),
        studySession: Map<String, int>.from(json['studySession']),
      );

  Map<String, dynamic> toJson() => {
        'mail': mail,
        'username': username,
        'tasks': tasks,
        'weeklyAvailability': weeklyAvailability,
        'studySession': studySession,
      };
}
