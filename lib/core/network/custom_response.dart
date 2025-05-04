import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class CustomResponse extends Equatable {
  final bool status;
  String? error;
  dynamic data;
  CustomResponse({required this.status, this.error, this.data});

  @override
  List<Object?> get props => [status];
}
