import 'dart:async';

import 'package:drift/drift.dart';

import 'database/database.dart';
import 'models/models.dart';

class LoggerRepository {
  LoggerRepository._();
  static final LoggerRepository instance = LoggerRepository._();

  final database = LogDataBase();

  StreamController<Log>? _controller;

  Stream<Log> get onRecord => _getStream();

  Future<void> addLog({
    required String name,
    required DateTime time,
    required int level,
    required String message,
    StackTrace? stackTrace,
  }) async {
    final log = await database.into(database.logEntries).insertReturning(
          LogEntriesCompanion.insert(
            name: name,
            level: level,
            time: time,
            message: message,
            stackTrace: Value(stackTrace?.toString()),
          ),
        );
    _publishAddLog(Log.fromDBEntrty(log));
  }

  Future<List<Log>> getLogs() async {
    return (await (database.select(database.logEntries)
              ..orderBy([(t) => OrderingTerm.desc(t.id)]))
            .get())
        .map((e) => Log.fromDBEntrty(e))
        .toList();
  }

  Future<Log?> getLog(int logId) async {
    return (await ((database.select(database.logEntries)
              ..where((item) => item.id.isValue(logId))))
            .get())
        .map((e) => Log.fromDBEntrty(e))
        .firstOrNull;
  }

  Future<int> cleanOldLogs(
      {Duration keepLogs = const Duration(days: 7)}) async {
    final now = DateTime.now();
    final compateDate = now.subtract(keepLogs);

    return (database.delete(database.logEntries)
          ..where((item) => item.time.isSmallerThanValue(compateDate)))
        .go();
  }

  void clearListeners() {
    _controller?.close();
    _controller = null;
  }

  Stream<Log> _getStream() {
    return (_controller ??= StreamController<Log>.broadcast(sync: true)).stream;
  }

  void _publishAddLog(Log log) => _controller?.add(log);
}
