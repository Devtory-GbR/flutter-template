part of 'log_list_cubit.dart';

enum LogListStatus { loading, success, failure }

class LogListState extends Equatable {
  const LogListState._({
    this.status = LogListStatus.loading,
    this.items = const <Log>[],
  });

  const LogListState.loading() : this._();

  const LogListState.success(List<Log> items)
      : this._(status: LogListStatus.success, items: items);

  const LogListState.failure() : this._(status: LogListStatus.failure);

  final LogListStatus status;
  final List<Log> items;

  @override
  List<Object> get props => [status, items];

  @override
  String toString() => 'status: $status, items: ${items.length}';
}
