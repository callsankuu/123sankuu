import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING, ERROR }

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey = 'b2f62a229268d3826549e9746518daa7';
  late WeatherFactory weatherFactory;
  List<Weather> weatherData = [];
  AppState appState = AppState.NOT_DOWNLOADED;
  double? lat, lon;

  @override
  void initState() {
    super.initState();
    weatherFactory = WeatherFactory(apiKey);
  }

  void queryWeather() async {
    if (lat == null || lon == null) {
      setState(() {
        appState = AppState.ERROR;
      });
      return;
    }

    setState(() {
      appState = AppState.DOWNLOADING;
    });

    try {
      Weather weather = await weatherFactory.currentWeatherByLocation(lat!, lon!);
      setState(() {
        weatherData = [weather];
        appState = AppState.FINISHED_DOWNLOADING;
      });
    } catch (e) {
      setState(() {
        appState = AppState.ERROR;
      });
      print('Error fetching weather: $e');
    }
  }

  void queryForecast() async {
    if (lat == null || lon == null) {
      setState(() {
        appState = AppState.ERROR;
      });
      return;
    }

    setState(() {
      appState = AppState.DOWNLOADING;
    });

    try {
      List<Weather> forecasts = await weatherFactory.fiveDayForecastByLocation(lat!, lon!);
      setState(() {
        weatherData = forecasts;
        appState = AppState.FINISHED_DOWNLOADING;
      });
    } catch (e) {
      setState(() {
        appState = AppState.ERROR;
      });
      print('Error fetching forecast: $e');
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Column(
          children: <Widget>[
            _coordinateInputs(),
            _buttons(),
            Text(
              'Output:',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            Expanded(child: _resultView())
          ],
        ),
      ),
    );
  }

  Widget _coordinateInputs() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter latitude',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => lat = double.tryParse(value),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter longitude',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => lon = double.tryParse(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: TextButton(
            onPressed: queryWeather,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Text(
              'Fetch weather',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: TextButton(
            onPressed: queryForecast,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Text(
              'Fetch forecast',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultView() {
    switch (appState) {
      case AppState.FINISHED_DOWNLOADING:
        return _buildWeatherList();
      case AppState.DOWNLOADING:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fetching Weather...',
                style: TextStyle(fontSize: 20),

              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        );
      case AppState.ERROR:
        return Center(
          child: Text(
            'Error fetching data. Please check your coordinates and try again.',
            textAlign: TextAlign.center,
          ),
        );
      case AppState.NOT_DOWNLOADED:
      default:
        return Center(
          child: Text(
            'Press the button to download the Weather forecast',
          ),
        );
    }
  }

  Widget _buildWeatherList() {
    return ListView.separated(
      itemCount: weatherData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(weatherData[index].toString()),
          leading:Container(
            height: 400,width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:AssetImage("assets/clouds.jpeg"),
                  fit:BoxFit.fill)
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

void main() {
  runApp(WeatherApp());
}
