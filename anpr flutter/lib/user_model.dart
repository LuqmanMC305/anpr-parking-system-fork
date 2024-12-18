import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String userId;
  String name;
  String phoneNumber;
  String email;
  String ic;
  String plateNumber;
  int wallet;

  UserModel({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.ic,
    required this.plateNumber,
    this.wallet = 100, // Default value of 100
  });

  factory UserModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>?;

    return UserModel(
      userId: snapshot.key ?? '',
      name: data?['name'] ?? '',
      phoneNumber: data?['phoneNumber'] ?? '',
      email: data?['email'] ?? '',
      ic: data?['ic'] ?? '',
      plateNumber: data?['plateNumber'] ?? '',
      wallet: data?['wallet'] ?? 0,
      // Parse the value to int or default to 100
      // Assign the value from snapshot or default to 100
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'ic': ic,
      'plateNumber': plateNumber,
      'wallet': wallet,
    };
  }

  static Future<UserModel?> getUserModel(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(userId);

    DataSnapshot? snapshot;
    await userRef.once().then((event) {
      snapshot = event.snapshot;
    });

    if (snapshot != null && snapshot!.value != null) {
      return UserModel.fromSnapshot(snapshot!);
    } else {
      return null;
    }
  }

  Future<void> updateUser({
    String? name,
    String? phoneNumber,
    String? email,
    String? ic,
    String? plateNumber,
    int? wallet,
  }) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(userId);

    if (name != null) {
      this.name = name;
    }
    if (phoneNumber != null) {
      this.phoneNumber = phoneNumber;
    }
    if (email != null) {
      this.email = email;
    }
    if (ic != null) {
      this.ic = ic;
    }
    if (plateNumber != null) {
      this.plateNumber = plateNumber;
    }
    if (wallet != null) {
      this.wallet = wallet;
    }
    await userRef.update(toJson());
  }
}
