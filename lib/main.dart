import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => new _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherStation weatherStation =
      new WeatherStation("c70cbb547edceaedd740370962bf9280");

  Future<Weather> _getWeather() async {
    Weather weather = await weatherStation.currentWeather();
    return weather;
  }

  String _buildGif(Weather _w) {
    switch (_w.weatherDescription) {
      case 'Thunderstorm':
        return "stormy";
        break;

      case 'Drizzle':
        return "rainy";
        break;

      case 'Rain':
        return "rainy";
        break;

      case 'Snow':
        return "snowy";
        break;

      case 'Clear':
        return "sunny";
        break;

      case 'Clouds':
        if (_w.cloudiness > .50) {
          return "partlycloudy";
        } else
          return "CloudyGif";
        break;

      default:
        return "cloudy";
    }
  }

  IconData _buildIcon(Weather _w) {
    switch (_w.weatherMain) {
      case 'Thunderstorm':
        return FontAwesomeIcons.cloudShowersHeavy;
        break;

      case 'Drizzle':
        return FontAwesomeIcons.cloudRain;
        break;

      case 'Rain':
        return FontAwesomeIcons.cloudRain;
        break;

      case 'Snow':
        return FontAwesomeIcons.snowflake;
        break;

      case 'Clear':
        return FontAwesomeIcons.sun;
        break;

      case 'Clouds':
        if (_w.cloudiness > .50) {
          return FontAwesomeIcons.cloudSun;
        } else
          return FontAwesomeIcons.cloud;
        break;

      default:
        return FontAwesomeIcons.cloud;
    }
  }

  String _buildText(String _w) {
    if(_w == "Thunderstorm")
      return "Storm";
    else if(_w == "Drizzle")
      return "Rain";
    else
      return _w;
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: FutureBuilder<Weather>(
          future: _getWeather(),
          builder: (context, w) {
            if (w.connectionState == ConnectionState.done) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/${_buildGif(w.data)}.gif")),
                      ),
                    ),
                    Center(
                        child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 325,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            w.data.areaName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Press Start',
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              " ${w.data.temperature.fahrenheit.toInt().toString()}\u00b0",
                              style: TextStyle(
                                fontSize: 50,
                                fontFamily: 'Press Start',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    _buildIcon(w.data),
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    _buildText(w.data.weatherMain),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: 'Press Start',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
