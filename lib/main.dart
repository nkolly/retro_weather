import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.white,
            fontSize: 28
          )
        ),
        fontFamily: 'Press Start'
      ),
      home: WeatherPg(),
    );
  }
}

class WeatherPg extends StatefulWidget {
  @override
  _WeatherPgState createState() => _WeatherPgState();
}

class _WeatherPgState extends State<WeatherPg> {
  WeatherStation weatherStation =
      new WeatherStation("YOUR--API--KEY--HERE");

  Future<Weather> _weather() async {
    Weather w = await weatherStation.currentWeather();
    return w;
  }

  String _gif(_w) {
    switch (_w.weatherMain) {
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
        return _w.cloudiness > .5 ? "partlycloudy" : "CloudyGif";
        break;

      default:
        return "cloudy";
    }
  }

  IconData _buildIcon(_w) {
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

  String _text(_w) {
    if(_w == "Thunderstorm")
      return "Storm";
    else if(_w == "Drizzle")
      return "Rain";
    else
      return _w;
  }


  @override
  Widget build(context) {
    return Material(
        type: MaterialType.transparency,
        child: FutureBuilder<Weather>(
          future: _weather(),
          builder: (context, w) {
            if (w.connectionState == ConnectionState.done) {
              return Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/${_gif(w.data)}.gif"))
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(15)
                      ),
                      height: 325,
                      width: 300,
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        w.data.areaName,
                        textAlign: TextAlign.center
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          " ${w.data.temperature.fahrenheit.toInt().toString()}\u00b0",
                          style: TextStyle(
                            fontSize: 50
                          )
                        )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              _buildIcon(w.data),
                              size: 70,
                              color: Colors.white
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                _text(w.data.weatherMain)
                              )
                            )
                          ]
                        )
                      )
                    ]
                      )
                    )
                  ]
                )
              );
            } else {
              return Center(
                child: CircularProgressIndicator()
              );
            }
          }
        ));
  }
}
