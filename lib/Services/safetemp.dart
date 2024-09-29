import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:smartrainbow/Services/temp_model.dart';

class PreferencesService {
  static const _key = 'temperatureComparisons';

  Future<void> saveTemperatureComparison(TemperatureComparison data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> comparisons = prefs.getStringList(_key) ?? [];
    if (comparisons.length == 25) {
      comparisons.removeAt(0); 
    }
    comparisons.add(json.encode(data.toJson()));
    
    await prefs.setStringList(_key, comparisons);
  }

  Future<List<TemperatureComparison>> getTemperatureComparisons() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> comparisonsJson = prefs.getStringList(_key) ?? [];
 
    return comparisonsJson.map((jsonStr) => TemperatureComparison.fromJson(json.decode(jsonStr))).toList();
  }

  // Add this method to manually delete the list
  Future<void> deleteTemperatureComparisons() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key); 
  }
}
