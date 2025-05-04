import 'package:ai_coach/production/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.mail,
    super.username,
    super.studyDuration,
    super.hourPerDay,
    super.busyHours,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        mail: json["mail"],
        username: json["username"],
        studyDuration: json["studyDuration"],
        hourPerDay: json["hourPerDay"],
        busyHours: List<Map<String, int>>.from(json["busyHours"]),
      );

  Map<String, dynamic> toJson() => {
        'mail': mail,
        'username': username,
        'studyDuration': studyDuration,
        'hourPerDay': hourPerDay,
        'busyHours': busyHours,
      };
}
