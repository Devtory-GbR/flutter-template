import 'package:equatable/equatable.dart';

import '../database/database.dart';

class Log extends Equatable {
  const Log(
      {required this.id,
      required this.name,
      required this.level,
      required this.time,
      required this.message,
      this.stackTrace});
  final int id;
  final String name;
  final int level;
  final DateTime time;
  final String message;
  final String? stackTrace;

  @override
  List<Object> get props => [id, name, level, time, message];

  factory Log.fromDBEntrty(LogEntry logEntry) {
    return Log(
      id: logEntry.id,
      name: logEntry.name,
      level: logEntry.level,
      time: logEntry.time,
      message: logEntry.message,
      stackTrace: logEntry.stackTrace,
    );
  }
  @override
  String toString() => 'id: $id, message: $message';
}
