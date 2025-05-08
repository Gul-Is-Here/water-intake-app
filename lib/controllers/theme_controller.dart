import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Preferences/preferences.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  var isDarkMode = false.obs; // For switch toggle state

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final savedTheme = await Preferences.getThemeMode();
    if (savedTheme != null) {
      themeMode.value = savedTheme == 'dark'
          ? ThemeMode.dark
          : savedTheme == 'light'
          ? ThemeMode.light
          : ThemeMode.system;
      isDarkMode.value = savedTheme == 'dark';
    }
  }

  void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    isDarkMode.value = isDark;
    Preferences.saveThemeMode(isDark ? 'dark' : 'light');
  }
}