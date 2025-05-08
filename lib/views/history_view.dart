import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/water_controller.dart';
import 'custom_bottom_nav.dart';

class HistoryView extends StatelessWidget {
  final WaterController _waterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Intake History',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() => TableCalendar(
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now(),
            focusedDay: _waterController.selectedDate.value,
            selectedDayPredicate: (day) =>
                isSameDay(_waterController.selectedDate.value, day),
            onDaySelected: (selectedDay, focusedDay) {
              _waterController.selectedDate.value = selectedDay;
            },
            calendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.montserrat(),
            ),
          )),
          Expanded(
            child: Obx(() {
              final selectedDate = _waterController.selectedDate.value;
              final dateIntakes = _waterController.intakeHistory
                  .where((intake) =>
              intake.date.year == selectedDate.year &&
                  intake.date.month == selectedDate.month &&
                  intake.date.day == selectedDate.day)
                  .toList()
                  .reversed
                  .toList();

              if (dateIntakes.isEmpty) {
                return Center(
                  child: Text(
                    'No intake recorded for this day',
                    style: GoogleFonts.openSans(),
                  ),
                );
              }

              return ListView.builder(
                itemCount: dateIntakes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.local_drink,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      '${dateIntakes[index].amount.toInt()} ml',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      dateIntakes[index].formattedTime,
                      style: GoogleFonts.openSans(),
                    ),
                    trailing: Text(
                      DateFormat('h:mm a').format(dateIntakes[index].date),
                      style: GoogleFonts.openSans(),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      // bottomNavigationBar: CustomBottomNav(currentIndex: 1,),
    );
  }
}