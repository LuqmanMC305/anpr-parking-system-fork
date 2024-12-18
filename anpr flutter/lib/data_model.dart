import 'package:firebase_database/firebase_database.dart';

class DataModel {
  final String date;
  final String details;
  final String fee;
  final String plate;
  final String ref;
  final String time;

  DataModel({
    required this.date,
    required this.details,
    required this.fee,
    required this.plate,
    required this.ref,
    required this.time,
  });

  factory DataModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>?;

    return DataModel(
      date: data?['date'] ?? '',
      details: data?['details'] ?? '',
      fee: data?['fee'] ?? '',
      plate: data?['plate'] ?? '',
      ref: data?['ref'] ?? '',
      time: data?['time'] ?? '',
    );
  }
}
