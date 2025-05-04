import 'package:equatable/equatable.dart';

//arayüzde kullanılacak durum için class
abstract class DataState<T> extends Equatable {
  final T? data;
  final String? error;
  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);

  @override
  // TODO: implement props
  List<Object?> get props => [data];
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(String error) : super(error: error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
