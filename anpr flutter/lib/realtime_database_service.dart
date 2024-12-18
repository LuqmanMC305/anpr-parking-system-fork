import 'package:firebase_database/firebase_database.dart';

import 'data_model.dart';

class RealtimeDatabaseService {
  final databaseReference = FirebaseDatabase.instance.ref();
  Stream<List<DataModel>> getDataListStream(String plate) {
    // Replace 'dataPath' with the actual path to your data in the Firebase Realtime Database
    final dataRef = databaseReference.child('record');

    return dataRef.onValue.map((event) {
      final dataSnapshots = event.snapshot.value as Map<dynamic, dynamic>?;
      final dataList = <DataModel>[];

      if (dataSnapshots != null) {
        final sortedKeys = dataSnapshots.keys.toList()
          ..sort(); // Get sorted keys
        for (final key in sortedKeys.reversed) {
          final value = dataSnapshots[key];
          if (value['plate'] == plate) {
            final data = DataModel(
              date: value['date'].toString(),
              fee: value['fee'].toString(),
              plate: value['plate'].toString(),
              ref: value['ref'].toString(),
              time: value['time'].toString(),
              details: value['details'].toString(),
            );
            dataList.add(data);
          }
        }
      }
      return dataList;
    });
  }
}
