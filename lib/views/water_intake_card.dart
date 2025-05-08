import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model/water_intake.dart';

class WaterIntakeCard extends StatelessWidget {
  final WaterIntake intake;

  WaterIntakeCard({required this.intake});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.local_drink,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${intake.amount.toInt()} ml',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  intake.formattedTime,
                  style: GoogleFonts.openSans(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              DateFormat('h:mm a').format(intake.date),
              style: GoogleFonts.openSans(),
            ),
          ],
        ),
      ),
    );
  }
}