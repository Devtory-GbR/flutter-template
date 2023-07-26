import 'package:http/http.dart';
import 'package:repositories/repositories.dart';

class TestRepository {
  Future<void> simulateError401() async {
    final client = MyAppHttpClient(Client());
    await client.get(Uri.https('httpstat.us', '/401'));
  }

  Future<void> simulateClientError() async {
    final client = MyAppHttpClient(Client());
    await client.get(Uri.https('api.myapp.com', '/ping'));
  }

  Future<void> simulateHttpError() async {
    final client = MyAppHttpClient(Client());
    await client.get(Uri.https('httpstat.us', '/404'));
  }
}
