import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/water_intake.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Daily Goal
  static Future<void> saveDailyGoal(int goal) async {
    await _prefs.setInt('dailyGoal', goal);
  }

  static int? getDailyGoal() {
    return _prefs.getInt('dailyGoal');
  }

  // Intake History
  static Future<void> saveIntakeHistory(List<WaterIntake> history) async {
    final jsonList = history.map((intake) => intake.toJson()).toList();
    await _prefs.setString('intakeHistory', jsonEncode(jsonList));
  }

  static List<WaterIntake>? getIntakeHistory() {
    final jsonString = _prefs.getString('intakeHistory');
    if (jsonString == null) return null;

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => WaterIntake.fromJson(json)).toList();
  }

  // Theme Mode
  static Future<void> saveThemeMode(String mode) async {
    await _prefs.setString('themeMode', mode);
  }

  static String? getThemeMode() {
    return _prefs.getString('themeMode');
  }
}