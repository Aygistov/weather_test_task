import 'package:hive_flutter/hive_flutter.dart';

Future<String> getCity() async {
  await Hive.openBox('city');
  final box = Hive.box('city');
  final String city = box.get('city') ?? '';
  return city;
}
