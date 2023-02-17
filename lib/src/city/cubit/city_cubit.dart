import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit(String city) : super(CityState(city)) {
    if (city.isNotEmpty) {
      updateCity(city);
      controller.text = city;
    }
  }

  updateCity(String city) {
    emit(CityState(city));
  }

  final TextEditingController controller = TextEditingController();
}
