import 'package:flutter/material.dart';
import 'package:flutter_weather_application/data/model/weather_model.dart';
import 'package:flutter_weather_application/data/provider/language_provider.dart';
import 'package:flutter_weather_application/data/provider/theme_provider.dart';
import 'package:flutter_weather_application/data/provider/weather_provider.dart';
import 'package:flutter_weather_application/ui/widget/dropdown.dart';
import 'package:flutter_weather_application/ui/widget/header_widget.dart';
import 'package:flutter_weather_application/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<WeatherModel> _weatherData;
  bool isDarkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    var weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    _weatherData = weatherProvider.getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (BuildContext context, LanguageProvider value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.current_weather),
            actions: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return Switch(
                    value: isDarkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        isDarkModeEnabled = value;
                        if (isDarkModeEnabled) {
                          themeProvider.setThemeData(AppTheme.darkTheme);
                        } else {
                          themeProvider.setThemeData(AppTheme.lightTheme);
                        }
                      });
                    },
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder<WeatherModel>(
                  future: _weatherData,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final sunriseTime = DateTime.fromMillisecondsSinceEpoch(
                          snapshot.data!.sys!.sunrise! * 1000);
                      final sunsetTime = DateTime.fromMillisecondsSinceEpoch(
                          snapshot.data!.sys!.sunset! * 1000);
                      final formatter = DateFormat('hh:mm a');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const DropDownWidget(),
                          const SizedBox(
                            height: 20,
                          ),
                          const HeaderWidget(),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.temperature}: ${snapshot.data!.main!.temp} °C',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.weather}: ${snapshot.data!.weather![0].description}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.humidity}: ${snapshot.data!.main!.humidity}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.wind_speed}: ${snapshot.data!.wind!.speed}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.sun_rise}: ${formatter.format(sunriseTime)}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.sun_set}: ${formatter.format(sunsetTime)}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.coordinates}: ${snapshot.data!.coord!.lat}, ${snapshot.data!.coord!.lon}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.base}: ${snapshot.data!.base}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '${AppLocalizations.of(context)!.visibility}: ${snapshot.data!.visibility}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


