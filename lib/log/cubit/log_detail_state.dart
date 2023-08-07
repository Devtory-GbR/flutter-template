part of 'log_detail_cubit.dart';

enum LogDetailStatus { loading, success, failure, notFound }

class LogDetailState extends Equatable {
  LogDetailState._({this.status = LogDetailStatus.loading, Log? item})
      : item = item ?? Log.empty();

  LogDetailState.loading() : this._();

  LogDetailState.success(item)
      : this._(status: LogDetailStatus.success, item: item);

  LogDetailState.failure() : this._(status: LogDetailStatus.failure);

  LogDetailState.notFound() : this._(status: LogDetailStatus.notFound);

  final LogDetailStatus status;
  final Log item;

  @override
  List<Object> get props => [status, item];

  @override
  String toString() => 'status: $status, item: ${item.id}';
}
