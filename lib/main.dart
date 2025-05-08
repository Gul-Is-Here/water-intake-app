import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_app/views/custom_bottom_nav.dart';
import 'package:water_app/views/history_view.dart';
import 'package:water_app/views/home.dart';
import 'package:water_app/views/settings_view.dart';
import 'package:water_app/views/splash.dart';
import 'package:water_app/views/stats_view.dart';

import 'Preferences/preferences.dart';
import 'constants/constants.dart';
import 'controllers/theme_controller.dart';
import 'controllers/water_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPreferences();

  // Ensure controllers are ready before app builds
  Get.put(ThemeController());
  Get.put(WaterController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'AquaTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white, // White background for light theme
        primaryColor: AppColors.primaryLight,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryLight,
          secondary: AppColors.secondaryLight,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black, // White background for light theme
        primaryColor: AppColors.primaryDark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryDark,
          secondary: AppColors.secondaryDark,
        ),
      ),
      themeMode: themeController.themeMode.value,  // Access the value of themeMode
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/', page: () => MainWrapper()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/history', page: () => HistoryView()),
        GetPage(name: '/stats', page: () => StatsView()),
        GetPage(name: '/settings', page: () => SettingsView()),
      ],
    );
  }
}

class MainWrapper extends StatelessWidget {
  final WaterController waterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: waterController.currentTabIndex.value,
        children: [
          HomeView(),
          HistoryView(),
          StatsView(),
          SettingsView(),
        ],
      )),
      bottomNavigationBar: Obx(() => CustomBottomNav(
        currentIndex: waterController.currentTabIndex.value,
      )),
    );
  }
}

class AppTabs {
  static const int home = 0;
  static const int history = 1;
  static const int stats = 2;
  static const int settings = 3;
}
