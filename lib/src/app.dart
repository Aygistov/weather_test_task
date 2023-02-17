import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weather_test_task/src/city/city_view.dart';
import 'package:weather_test_task/src/weather/cubit/weather_cubit.dart';
import 'package:weather_test_task/src/weather/weather_view.dart';

import 'city/cubit/city_cubit.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key, required this.settingsController, required this.city});

  final SettingsController settingsController;
  final String city;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CityCubit(city)),
        BlocProvider(create: (context) => WeatherCubit(city)),
      ],
      child: AnimatedBuilder(
        animation: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    case WeatherView.routeName:
                      return const WeatherView();
                    case CityView.routeName:
                      return const CityView();
                    default:
                      return city.isEmpty
                          ? const CityView()
                          : const WeatherView();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
