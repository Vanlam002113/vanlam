import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ModelClass {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final int value;
  @HiveField(2)
  final String passwork;

  ModelClass(
      {required this.username, required this.passwork, required this.value});
}
