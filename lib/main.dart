import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_test_task/src/city/city.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  await Hive.initFlutter();
  String city = await getCity();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController, city: city));
}
