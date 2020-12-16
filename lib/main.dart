import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_weather/get_weather.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color bgcolor = Color(0xff3cb9fc);

  String cityName;
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String weatherMessage;
  DateTime now = DateTime.now();

  bool isFetched = false;

  String formattedTime = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: (isFetched ? Text("$cityName") : Text('Get Location')),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              isFetched = true;
              var weatherData = await weather.getCityWeather(cityName);
              print(weatherData);
              setState(() {
                formattedTime = DateFormat.H().format(now);
                print(formattedTime);
                if (int.parse(formattedTime) > 16) {
                  bgcolor = Color(0xff3e4157);
                }
                if (weatherData == null) {
                  temperature = 0;
                  weatherIcon = 'Error';
                  weatherMessage = 'Unable to get weather data';
                  cityName = '';
                  return;
                }
                double temp = weatherData['main']['temp'].toDouble();
                print(temp);
                temperature = temp.toInt();
                weatherMessage = weatherData['weather'][0]['description'];

                cityName = weatherData['name'];
              });
              // Navigator.pop(context, cityName);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              (isFetched
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(20.0),
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        onEditingComplete: () async {
                          isFetched = true;
                          var weatherData =
                              await weather.getCityWeather(cityName);
                          print(weatherData);
                          setState(() {
                            formattedTime = DateFormat.H().format(now);
                            print(formattedTime);
                            if (int.parse(formattedTime) > 16) {
                              bgcolor = Color(0xff3e4157);
                            }
                            if (weatherData == null) {
                              temperature = 0;
                              weatherIcon = 'Error';
                              weatherMessage = 'Unable to get weather data';
                              cityName = '';
                              return;
                            }
                            double temp =
                                weatherData['main']['temp'].toDouble();
                            print(temp);
                            temperature = temp.toInt();
                            weatherMessage =
                                weatherData['weather'][0]['description'];

                            cityName = weatherData['name'];
                          });
                          // Navigator.pop(context, cityName);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 25, 200, 238),
                          hintText: 'Enter City Name',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              color: Color.fromARGB(255, 25, 200, 238),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          cityName = value;
                        },
                      ),
                    )),

              // Container(
              //   padding: EdgeInsets.all(20.0),
              //   child: TextField(
              //     style: TextStyle(
              //       color: Colors.black,
              //     ),
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Color.fromARGB(255, 25, 200, 238),
              //       hintText: 'Enter City Name',
              //       hintStyle: TextStyle(
              //         color: Colors.grey,
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(100.0),
              //         ),
              //         borderSide: BorderSide(
              //           width: 0,
              //           color: Color.fromARGB(255, 25, 200, 238),
              //         ),
              //       ),
              //     ),
              //     onChanged: (value) {
              //       cityName = value;
              //     },
              //   ),
              // ),
              Visibility(
                visible: isFetched,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(top: 200.0, bottom: 20.0, left: 10.0),
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('images/sunny.png'),
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              Visibility(
                visible: isFetched,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  height: 150.0,
                  child: Card(
                    elevation: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$temperature°',
                            style: TextStyle(fontSize: 38.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("$weatherMessage"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isFetched,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  height: 150.0,
                  child: Card(
                    elevation: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Coming soon"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
