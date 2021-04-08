import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_weather/get_weather.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/constants.dart';
import 'package:weather/widgets/textfield.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color timecolor = Color(0xff81d5ff);
  Color cardColor = Colors.white;

  TextEditingController cityController = new TextEditingController();
  SharedPreferences sharedPreferences;
  WeatherModel weather = WeatherModel();
  bool hasCity = false;
  bool hasData = false;
  String prefCity = '';
  DateTime now = DateTime.now();
  int temperature = 0;
  int feeltemperature = 0;
  String weatherMessage = '';
  String cityName;
  String formattedTime = "";
  String weatherIcon = '';
  int weatherPressure = 0;

  void fetchData() async {
    var weatherData =
        await weather.getCityWeather(sharedPreferences.getString('city'));
    setState(() {
      hasData = true;
      print(weatherData);
      formattedTime = DateFormat.H().format(now);
      if (int.parse(formattedTime) > 10) {
        timecolor = Color(0xff48688d);
      }
      double temp = weatherData['main']['temp'].toDouble();
      double ftemp = weatherData['main']['feels_like'].toDouble();
      weatherPressure = weatherData['main']['pressure'];
      temperature = temp.toInt();
      feeltemperature = ftemp.toInt();
      weatherMessage = weatherData['weather'][0]['main'];
      weatherIcon = weatherData['weather'][0]['icon'];
    });
  }

  setPref(String city) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString('city', city);
      hasCity = true;
      prefCity = city;
      fetchData();
    });
  }

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      prefCity = sharedPreferences.getString('city');
      hasCity = (prefCity ?? '').isNotEmpty;
      if (hasCity)
        fetchData();
      else {
        _showMyDialog();
      }
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  double opacityLevel = 1.0;

  void _changeOpacity() {
    for (int i = 0; i < 365; i++)
      setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  IconData getIconData(String iconCode) {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;
      case '02d':
        return WeatherIcons.day_cloudy;
      case '02n':
        return WeatherIcons.day_cloudy;
      case '03d':
      case '04d':
        return WeatherIcons.day_cloudy;
      case '03n':
      case '04n':
        return WeatherIcons.night_clear;
      case '09d':
        return WeatherIcons.day_showers;
      case '09n':
        return WeatherIcons.night_showers;
      case '10d':
        return WeatherIcons.day_rain;
      case '10n':
        return WeatherIcons.night_rain;
      case '11d':
        return WeatherIcons.day_thunderstorm;
      case '11n':
        return WeatherIcons.night_thunderstorm;
      case '13d':
        return WeatherIcons.day_snow;
      case '13n':
        return WeatherIcons.night_snow;
      case '50d':
        return WeatherIcons.day_fog;
      case '50n':
        return WeatherIcons.night_fog;
      default:
        return WeatherIcons.day_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    _changeOpacity();
    return Scaffold(
      appBar: AppBar(
        // title: Text(kAppName),
        title: (hasCity
            ? Text(sharedPreferences.getString('city'))
            : Text(kAppName)),
      ),
      body: (hasCity
          ? (hasData
              ? ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        title: Text(
                          '$temperature°',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                        subtitle: Text(
                          '$weatherMessage',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        trailing:
                            Icon(getIconData(weatherIcon), color: Colors.black),
                        tileColor: timecolor,
                        onTap: (){},
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Feels like $feeltemperature°', style: TextStyle(fontSize: 15)),
                            Divider(),
                            Text('Pressure : $weatherPressure' + 'hPa', style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ))
          : Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 100,
                  child: AnimatedOpacity(
                    opacity: opacityLevel,
                    duration: Duration(seconds: 3),
                    child: Icon(
                      CupertinoIcons.brightness,
                      size: 250.0,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 400,
                  child: Center(
                      child: Text(
                    'No City Found!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 450,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.location),
                    onPressed: () {
                      _showMyDialog();
                    },
                    tooltip: 'Press here to fetch your city',
                  ),
                ),
              ],
            )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fetch Your City'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RSTextField(
                  hint: 'Enter your city',
                  controller: cityController,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Get'),
              onPressed: () {
                setPref(cityController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
