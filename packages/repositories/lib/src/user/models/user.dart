import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id});

  final String id;

  @override
  List<Object> get props => [id];

  static const empty = User(id: '');

  @override
  String toString() => '{id: $id}';
}
