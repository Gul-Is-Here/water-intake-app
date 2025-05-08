
import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../Preferences/preferences.dart';
import '../model/water_intake.dart';

class WaterController extends GetxController {
  var currentTabIndex = 0.obs;
  var dailyGoal = 2000.obs;
  var currentIntake = 0.0.obs;
  var intakeHistory = <WaterIntake>[].obs;
  var selectedDate = DateTime.now().obs;
  var goalAchieved = false.obs;
  var lastCheckedDay = DateTime.now().day.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
    // Check for new day periodically
    Timer.periodic(Duration(minutes: 15), (_) => checkNewDay());
  }

  void changeTabIndex(int index) {
    currentTabIndex.value = index;
  }

  Future<void> loadData() async {
    dailyGoal.value = await Preferences.getDailyGoal() ?? 2000;
    intakeHistory.value = await Preferences.getIntakeHistory() ?? [];
    updateCurrentIntake();
  }

  void checkNewDay() {
    final now = DateTime.now();
    if (now.day != lastCheckedDay.value) {
      goalAchieved.value = false;
      lastCheckedDay.value = now.day;
    }
  }

  void updateCurrentIntake() {
    final today = DateTime.now();
    final todayIntakes = intakeHistory.where(
          (intake) =>
      intake.date.year == today.year &&
          intake.date.month == today.month &&
          intake.date.day == today.day,
    );

    currentIntake.value = todayIntakes.fold(
      0.0,
          (double sum, intake) => sum + intake.amount,
    );

    // Check if goal was achieved
    if (!goalAchieved.value && currentIntake.value >= dailyGoal.value) {
      goalAchieved.value = true;
      showCongratsPopup();
    } else if (currentIntake.value < dailyGoal.value) {
      goalAchieved.value = false;
    }
  }

  void showCongratsPopup() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "🎉 Congratulations!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("You've reached your daily water goal of ${dailyGoal.value}ml!"),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void addIntake(double amount) {
    final intake = WaterIntake(amount: amount, date: DateTime.now());
    intakeHistory.add(intake);
    Preferences.saveIntakeHistory(intakeHistory);
    updateCurrentIntake();
  }

  void setDailyGoal(int goal) {
    dailyGoal.value = goal;
    Preferences.saveDailyGoal(goal);
  }

  // Feature to reset the daily goal and intake
  void resetDailyGoal() {
    // Reset the goal and current intake
    dailyGoal.value = 2000; // You can set it to a default value or a custom one
    currentIntake.value = 0.0;
    // Optionally reset intake history if you want to clear everything
    intakeHistory.clear();
    Preferences.saveDailyGoal(dailyGoal.value);
    Preferences.saveIntakeHistory(intakeHistory);
    // Also reset the goal achieved flag
    goalAchieved.value = false;
    // Inform the user
    Get.snackbar("Goal Reset", "Your daily goal has been reset!");
  }


  double getWeeklyAverage() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));

    final weekIntakes = intakeHistory.where(
          (intake) => intake.date.isAfter(weekAgo),
    );

    if (weekIntakes.isEmpty) return 0.0;

    final total = weekIntakes.fold(
      0.0,
          (double sum, intake) => sum + intake.amount,
    );
    return total / 7;
  }

  Map<DateTime, double> getDailyIntakesForMonth() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    Map<DateTime, double> result = {};

    for (var i = 0; i < now.day; i++) {
      final date = monthStart.add(Duration(days: i));
      final dayIntakes = intakeHistory.where(
            (intake) =>
        intake.date.year == date.year &&
            intake.date.month == date.month &&
            intake.date.day == date.day,
      );

      result[date] = dayIntakes.fold(
        0.0,
            (double sum, intake) => sum + intake.amount,
      );
    }

    return result;
  }

  String getFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
