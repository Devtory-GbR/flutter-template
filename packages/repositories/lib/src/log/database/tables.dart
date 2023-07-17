import 'package:drift/drift.dart';

@DataClassName('LogEntry')
class LogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get level => integer()();
  DateTimeColumn get time => dateTime()();
  TextColumn get message => text()();
  TextColumn get stackTrace => text().nullable()();
}
