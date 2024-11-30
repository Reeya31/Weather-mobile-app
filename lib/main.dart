import 'package:flutter/material.dart';
import 'services/weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  String? _city = "Kathmandu"; // Default city
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _getWeather(); // Fetching weather for the default city
  }

  void _getWeather() async {
    if (_city == null || _city!.isEmpty) return;
    try {
      final data = await _weatherService.fetchWeather(_city!);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: SingleChildScrollView(
      child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _city = value,
            ),
            // SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Get Weather',style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            if (_weatherData != null) ...[
              // SizedBox(height: 20),
              Text(_city!, style: const TextStyle(fontSize:40 ),),
              //  SizedBox(height: 4),
              if (_weatherData!['weather'][0]['icon'] != null)
                Image.network(
                  'https://openweathermap.org/img/wn/${_weatherData!['weather'][0]['icon']}@2x.png',
                  width: 100,
                  height: 100,
                ),
              Text(
                'Temperature: ${_weatherData!['main']['temp']} °C',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Condition: ${_weatherData!['weather'][0]['description']}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    )
    );
  }
}
