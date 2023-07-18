import 'dart:async';

import 'package:repositories/src/user/repository.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  Future<User> getUser() async {
    // TODO usally we would call here a real api to get the user data
    // for now we just return a dummy user
    await Future.delayed(const Duration(milliseconds: 300));
    return User(id: const Uuid().v4(), name: "Max");
  }
}
