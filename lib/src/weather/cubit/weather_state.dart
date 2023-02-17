part of 'weather_cubit.dart';

class WeatherState extends Equatable {
  const WeatherState(
      {this.city = '',
      this.errorText = '',
      this.cityWasFound = false,
      this.weather,
      this.forecast = const []});

  //final String city;
  final String errorText;

  final List<Weather> forecast;
  final Weather? weather;
  final bool cityWasFound;
  final String city;

  @override
  List<Object> get props => [city, errorText];
}
