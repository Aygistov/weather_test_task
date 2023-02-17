import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/weather.dart';
import 'package:weather_test_task/src/constrains/api.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(String city) : super(const WeatherState()) {
    if (city.isNotEmpty) {
      getWeather(city);
    }
  }

  Future<bool> getWeather(String city) async {
    WeatherFactory wf = WeatherFactory(apiKey);
    try {
      Weather weather = await wf.currentWeatherByCityName(city);
      List<Weather> forecast = await wf.fiveDayForecastByCityName(city);
      final box = Hive.box('city');
      box.put('city', city);
      box.flush();

      emit(WeatherState(
          city: city,
          weather: weather,
          forecast: forecast,
          cityWasFound: true));
      return true;
    } catch (e) {
      emit(WeatherState(errorText: e.toString()));
      return false;
    }
  }

  clearError() {
    emit(const WeatherState(errorText: ''));
  }
}
