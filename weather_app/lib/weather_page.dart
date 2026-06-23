import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'weather_services.dart';
import 'weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final weatherServices = WeatherServices("2febea9df74523520f1068c88985ad90");
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await weatherServices.getCurrentCity();
    //get weather for city
    try{
      final weather = await weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      // ignore: avoid_print
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/windy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //city name
              Text(_weather?.cityName ?? "loading city...", style: GoogleFonts.righteous(fontSize: 32, fontWeight: FontWeight.w400)),
        
              //animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
        
              //temprature
              Text('${_weather?.temprature.round() ?? 0}°C', style: GoogleFonts.righteous(fontSize: 24, fontWeight: FontWeight.w200))
            ],
          ),
        ),
      ),
    );
  }
}
