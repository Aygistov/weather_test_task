import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather/weather.dart';
import 'package:weather_test_task/src/city/city_view.dart';
import 'package:weather_test_task/src/settings/settings_view.dart';
import 'package:weather_test_task/src/weather/cubit/weather_cubit.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({
    super.key,
  });

  static const routeName = '/weather';

  @override
  Widget build(BuildContext context) {
    WeatherState state = context.watch<WeatherCubit>().state;
    final List<Weather> forecast = state.forecast;
    final Weather? weather = state.weather;

    Map<dynamic, dynamic> forecastData = getForecastData(forecast);
    List<ChartData> chartData = getChartData(forecast);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, CityView.routeName);
            }),
        title: const Text('Weather'),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, SettingsView.routeName);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              WeatherWidget(weather: weather),
              ForecastWidget(forecastData: forecastData),
              ChartWidget(chartData: chartData)
            ],
          ),
        ),
      ),
    );
  }

  List<ChartData> getChartData(List<Weather> forecast) {
    final List<ChartData> chartData = [];
    for (var e in forecast) {
      chartData.add(ChartData(e.date!, e.temperature!.celsius));
    }
    return chartData;
  }

  Map<dynamic, dynamic> getForecastData(List<Weather> forecast) {
    Set<DateTime> days = {};
    for (var e in forecast) {
      days.add(DateTime(e.date!.year, e.date!.month, e.date!.day));
    }
    Map daysData = {};
    for (var e in days) {
      daysData[e] = {
        'tempMin': double.infinity,
        'tempMax': double.negativeInfinity,
        'weatherMain': ''
      };
    }
    for (var e in forecast) {
      daysData[DateTime(e.date!.year, e.date!.month, e.date!.day)]['tempMin'] =
          min(
              e.tempMin!.celsius!,
              daysData[DateTime(e.date!.year, e.date!.month, e.date!.day)]
                  ['tempMin'] as double);
      daysData[DateTime(e.date!.year, e.date!.month, e.date!.day)]['tempMax'] =
          max(
              e.tempMax!.celsius!,
              daysData[DateTime(e.date!.year, e.date!.month, e.date!.day)]
                  ['tempMax'] as double);
      daysData[DateTime(e.date!.year, e.date!.month, e.date!.day)]
          ['weatherMain'] = e.weatherMain;
    }
    return daysData;
  }
}

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({
    super.key,
    required this.forecastData,
  });

  final Map forecastData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: forecastData.entries
            .map((entry) => ForecastCardWidget(
                  day: entry.key,
                  tempMin: entry.value['tempMin'],
                  tempMax: entry.value['tempMax'],
                  weatherMain: entry.value['weatherMain'],
                ))
            .toList(),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.weather,
  });

  final Weather? weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('City: ${weather?.areaName ?? '-'}'),
        Text('Weather: ${weather?.weatherDescription ?? '-'}'),
        Text(
            'Temperature: ${weather?.temperature?.celsius?.toStringAsFixed(0) ?? '-'}°C'),
        Text('Humidity: ${weather?.humidity?.toStringAsFixed(0) ?? '-'}%'),
        Text('Pressure: ${weather?.pressure?.toStringAsFixed(0) ?? '-'}hPa'),
      ],
    );
  }
}

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
    required this.chartData,
  });

  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(dateFormat: DateFormat("dd MMMM \n HH:00")),
        primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
        series: <ChartSeries>[
          // Renders spline chart
          SplineSeries<ChartData, DateTime>(
              xAxisName: 'date/time',
              yAxisName: '°C',
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ]);
  }
}

class ForecastCardWidget extends StatelessWidget {
  const ForecastCardWidget({
    super.key,
    required this.day,
    required this.tempMin,
    required this.tempMax,
    required this.weatherMain,
  });

  final DateTime day;
  final double tempMin;
  final double tempMax;
  final String weatherMain;

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("dd MMMM");

    return Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(format.format(day)),
              Text(weatherMain),
              Text(
                  '${tempMax.toStringAsFixed(0)}°  ${tempMin.toStringAsFixed(0)}°'),
            ],
          ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double? y;
}
