import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object> get props => [id];

  static const empty = User(id: '', name: '');

  @override
  String toString() => '{id: $id}';
}
