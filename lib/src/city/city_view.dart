import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test_task/src/city/cubit/city_cubit.dart';
import 'package:weather_test_task/src/weather/cubit/weather_cubit.dart';
import 'package:weather_test_task/src/weather/weather_view.dart';

class CityView extends StatelessWidget {
  const CityView({
    super.key,
  });

  static const routeName = '/city';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('City'),
        leading: const SizedBox(height: 0, width: 0),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Enter a city name',
                      ),
                      controller: context.read<CityCubit>().controller,
                      autofocus: true,
                      onChanged: (value) {
                        context.read<CityCubit>().updateCity(value.toString());
                        context.read<WeatherCubit>().clearError();
                      },
                    ),
                  ),
                  IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: context.watch<CityCubit>().state.city.isEmpty
                          ? null
                          : () {
                              context
                                  .read<WeatherCubit>()
                                  .getWeather(
                                      context.read<CityCubit>().state.city)
                                  .then((ok) => {
                                        if (ok)
                                          {
                                            Navigator.restorablePushNamed(
                                                context, WeatherView.routeName)
                                          }
                                      });
                            },
                      icon: const Icon(Icons.search))
                ],
              ),
              Text(context.watch<WeatherCubit>().state.errorText)
            ],
          ),
        ),
      ),
    );
  }
}
