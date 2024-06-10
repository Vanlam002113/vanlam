import 'package:hive/hive.dart';
part 'model_data.g.dart';

@HiveType(typeId: 0)
class ModelClass {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final int value;
  @HiveField(2)
  final String passwork;
  @HiveField(3)
  final int value2;
  @HiveField(4)
  final String email;

  ModelClass(
      {required this.username,
      required this.passwork,
      required this.value,
      required this.value2,
      required this.email});
}
