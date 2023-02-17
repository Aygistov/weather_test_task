part of 'city_cubit.dart';

class CityState extends Equatable {
  const CityState(
    this.city,
  );

  final String city;

  @override
  List<Object> get props => [city];
}
