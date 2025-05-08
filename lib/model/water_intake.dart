import 'package:intl/intl.dart';

class WaterIntake {
  final double amount;
  final DateTime date;

  WaterIntake({
    required this.amount,
    required this.date,
  });

  String get formattedTime => DateFormat('HH:mm').format(date);

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'date': date.toIso8601String(),
  };

  factory WaterIntake.fromJson(Map<String, dynamic> json) => WaterIntake(
    amount: json['amount'].toDouble(),
    date: DateTime.parse(json['date']),
  );
}