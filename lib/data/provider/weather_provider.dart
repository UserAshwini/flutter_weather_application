import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_weather_application/data/model/weather_model.dart';
import 'package:http/http.dart' as http;


class WeatherProvider extends ChangeNotifier {
  // create various variables
  final bool _isLoading = true;
  final double _latitude = 0.0;
  final double _longitude = 0.0;
  final int _currentIndex = 0;
  String _name = "";
  final _date = DateTime.now();

  // create instance
  bool get isLoading => _isLoading;
  double get latitude => _latitude;
  double get longitude => _longitude;
  int get currentIndex => _currentIndex;
  String get name => _name;
  String get date => _date.toString();

  final WeatherModel _weatherModel = WeatherModel();

  WeatherModel get weatherModel => _weatherModel;

  // WeatherProvider() {}

  Future<WeatherModel> getWeatherData() async {
    const url =
        'https://api.openweathermap.org/data/2.5/weather?lat=40.7591622&lon=-74.0516331&appid=3ca80dd1d24bea30f9d4290f9f3ef771';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
    final WeatherModel weatherModel = WeatherModel.fromJson(data);
    _name = weatherModel.name ?? "";
    return weatherModel;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

}
