import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
// api dan aldığımız istekleri kullanacağımız class
class CustomResponse extends Equatable {
  final bool status;
  String? error;
  dynamic data;
  CustomResponse({required this.status, this.error, this.data});

  @override
  List<Object?> get props => [status];
}
