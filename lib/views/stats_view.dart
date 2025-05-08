import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/water_controller.dart';
import 'custom_bottom_nav.dart';

class StatsView extends StatelessWidget {
  final WaterController _waterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hydration Stats',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Weekly Average
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Weekly Average',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() => Text(
                      '${_waterController.getWeeklyAverage().toStringAsFixed(0)} ml',
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Monthly Chart
            Text(
              'Monthly Progress',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              child: Obx(() {
                final monthlyData = _waterController.getDailyIntakesForMonth();
                final chartData = monthlyData.entries.map((entry) =>
                    ChartData(entry.key, entry.value)
                ).toList();

                return SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelRotation: -45,
                    labelStyle: GoogleFonts.openSans(fontSize: 10),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'ml'),
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) =>
                          DateFormat('MMM dd').format(data.date),
                      yValueMapper: (ChartData data, _) => data.amount,
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: 20),

            // Time of Day Chart
            Text(
              'Intake by Time of Day',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              child: Obx(() {
                final intakes = _waterController.intakeHistory;
                if (intakes.isEmpty) {
                  return Center(
                    child: Text(
                      'No data available',
                      style: GoogleFonts.openSans(),
                    ),
                  );
                }

                // Group by hour
                Map<int, double> hourData = {};
                for (var i = 0; i < 24; i++) {
                  hourData[i] = 0;
                }

                for (var intake in intakes) {
                  final hour = intake.date.hour;
                  hourData[hour] = hourData[hour]! + intake.amount;
                }

                final chartData = hourData.entries.map((entry) =>
                    TimeChartData(entry.key, entry.value)
                ).toList();

                return SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    minimum: 0,
                    maximum: 23,
                    interval: 2,
                    title: AxisTitle(text: 'Hour of Day'),
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'ml'),
                  ),
                  series: <CartesianSeries>[
                    LineSeries<TimeChartData, int>(
                      dataSource: chartData,
                      xValueMapper: (TimeChartData data, _) => data.hour,
                      yValueMapper: (TimeChartData data, _) => data.amount,
                      color: Theme.of(context).colorScheme.primary,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNav(currentIndex: 2,),
    );
  }
}

class ChartData {
  final DateTime date;
  final double amount;

  ChartData(this.date, this.amount);
}

class TimeChartData {
  final int hour;
  final double amount;

  TimeChartData(this.hour, this.amount);
}