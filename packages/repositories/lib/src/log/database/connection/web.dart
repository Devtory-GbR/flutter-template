import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Obtains a database connection for running drift on the web.
DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future.sync(() async {
    final storage = await DriftWebStorage.indexedDbIfSupported('logs');
    final databaseImpl = WebDatabase.withStorage(storage);

    return DatabaseConnection(databaseImpl);
  }));
}
