import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../controllers/water_controller.dart';

class SettingsView extends StatelessWidget {
  final WaterController _waterController = Get.find();
  final ThemeController _themeController = Get.find();
  final goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    goalController.text = _waterController.dailyGoal.value.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Water Goal',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount in ml',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final goal = int.tryParse(goalController.text) ?? 2000;
                    _waterController.setDailyGoal(goal);
                    Get.snackbar(
                      'Success',
                      'Daily goal updated to $goal ml',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Text('Save'),
                ),
              ],
            ),

            SizedBox(height: 30),

            Text(
              'Appearance',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Wrap only the part that needs to change in Obx
            Obx(() => SwitchListTile(
              title: Text('Dark Mode'),
              value: _themeController.isDarkMode.value,
              onChanged: (value) {
                _themeController.toggleTheme(value);
                // Force app to rebuild with new theme
                Get.changeThemeMode(_themeController.themeMode.value);
              },
            )),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _waterController.resetDailyGoal();
                },
                child: Text("Reset Goal"),
              ),
            ),

            Text(
              'About',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AquaTrack',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: GoogleFonts.openSans(),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Stay hydrated and track your daily water intake with AquaTrack.',
                      style: GoogleFonts.openSans(),
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
