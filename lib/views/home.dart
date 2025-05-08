// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_app/views/water_intake_card.dart';

import '../constants/constants.dart' show AppColors;
import '../controllers/water_controller.dart';
import 'custom_bottom_nav.dart';

class HomeView extends StatelessWidget {
  final WaterController _waterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AquaTrack',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Indicator
            Obx(
              () => CircularPercentIndicator(
                radius: 120,
                lineWidth: 15,
                percent: (_waterController.currentIntake.value /
                        _waterController.dailyGoal.value)
                    .clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_waterController.currentIntake.value.toInt()}ml',
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'of ${_waterController.dailyGoal.value}ml',
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                  ],
                ),
                progressColor: AppColors.primaryLight,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondary.withOpacity(0.1),
              ),
            ),

            const SizedBox(height: 30),

            // Quick Add Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  [100, 250, 500].map((amount) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryLight,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed:
                          () => _waterController.addIntake(amount.toDouble()),
                      child: Text('+${amount}ml'),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 30),

            // Today's Intakes
            Text(
              'Today\'s Intakes',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              final todayIntakes =
                  _waterController.intakeHistory
                      .where(
                        (intake) =>
                            intake.date.year == DateTime.now().year &&
                            intake.date.month == DateTime.now().month &&
                            intake.date.day == DateTime.now().day,
                      )
                      .toList()
                      .reversed
                      .toList();

              if (todayIntakes.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No water intake recorded today',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return Column(
                children:
                    todayIntakes
                        .map((intake) => WaterIntakeCard(intake: intake))
                        .toList(),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryLight,
        child: const Icon(Icons.add),
        onPressed: () => _showAddIntakeDialog(context),
      ),
    );
  }

  void _showAddIntakeDialog(BuildContext context) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Water Intake'),
            content: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (ml)',
                suffixText: 'ml',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text) ?? 0;
                  if (amount > 0) {
                    _waterController.addIntake(amount);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
