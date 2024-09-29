class TemperatureComparison {
  final DateTime historicalDate;
  final double historicalTemperature;
  final double currentTemperature;
  final double temperatureDifference;

  TemperatureComparison({
    required this.historicalDate,
    required this.historicalTemperature,
    required this.currentTemperature,
    required this.temperatureDifference,
  });

  Map<String, dynamic> toJson() => {
        'historicalDate': historicalDate.toIso8601String(),
        'historicalTemperature': historicalTemperature,
        'currentTemperature': currentTemperature,
        'temperatureDifference': temperatureDifference,
      };

  factory TemperatureComparison.fromJson(Map<String, dynamic> json) => TemperatureComparison(
        historicalDate: DateTime.parse(json['historicalDate']),
        historicalTemperature: json['historicalTemperature'],
        currentTemperature: json['currentTemperature'],
        temperatureDifference: json['temperatureDifference'],
      );
}
