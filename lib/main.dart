import 'package:flutter/material.dart';
import 'package:get_weather/get_weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  String cityName;
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String weatherMessage;

  bool isFetched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3cb9fc),
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
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                ),
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
            ),
            Visibility(
              visible: isFetched,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20.0),
                child: Image(
                  image: AssetImage('images/sunny.png'),
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Visibility(
              visible: isFetched,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Temperature :"),
                        Text('$temperature°'),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("City name :"),
                        Text("$cityName"),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Description :"),
                        Text("$weatherMessage"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
