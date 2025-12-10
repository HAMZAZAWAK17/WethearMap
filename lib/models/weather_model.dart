class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double pressure;
  final double windSpeed;
  final DateTime date;
  final double tempMin;
  final double tempMax;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.date,
    required this.tempMin,
    required this.tempMax,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String city) {
    return WeatherModel(
      cityName: city,
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
    );
  }
}

class ForecastModel {
  final List<WeatherModel> forecasts;

  ForecastModel({required this.forecasts});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    List<WeatherModel> forecastList = [];
    String cityName = json['city']['name'];
    
    for (var item in json['list']) {
      forecastList.add(WeatherModel.fromJson(item, cityName));
    }
    
    return ForecastModel(forecasts: forecastList);
  }

  // Get daily forecasts (one per day)
  List<WeatherModel> getDailyForecasts() {
    Map<String, WeatherModel> dailyMap = {};
    
    for (var forecast in forecasts) {
      String dateKey = '${forecast.date.year}-${forecast.date.month}-${forecast.date.day}';
      
      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = forecast;
      }
    }
    
    return dailyMap.values.toList().take(3).toList();
  }
}
