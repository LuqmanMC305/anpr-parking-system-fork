import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'login.dart';
import 'realtime_database_service.dart';
import 'data_model.dart';
import 'user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ANPR',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading screen while checking the user's login status
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData) {
              // User is already signed in, navigate to the home screen
              return MyHomePage(userId: snapshot.data!.uid);
            } else {
              // User is not signed in, show the login screen
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}

class IconContainer extends StatefulWidget {
  final IconData icon;
  final String text;

  const IconContainer({super.key, required this.icon, required this.text});

  @override
  _IconContainerState createState() => _IconContainerState();
}

class _IconContainerState extends State<IconContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the container press event
        print('Container pressed: ${widget.text}');
      },
      child: Column(
        children: [
          Icon(
            widget.icon,
            size: 45.0,
            color: Color(0xFF0157C8),
          ),
          SizedBox(height: 10.0),
          Text(
            widget.text,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String userId;

  MyHomePage({super.key, required this.userId});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lastUpdateRecord = "";
  final primaryColor = Color(0xFF0157C8);
  final secondaryColor = Colors.yellowAccent;
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);
  int currentIndex = 0;
  int walletDisplay = 0;

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Handle successful sign-out
      print('User signed out');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Handle sign-out errors
      print('Sign-out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.userId);

    Future<UserModel?> getUserModel() async {
      UserModel? userModel = await UserModel.getUserModel(widget.userId);
      if (userModel != null) {
        return userModel;
      } else {
        // Handle error when UserModel is null
        print('UserModel is null');
        return null;
      }
    }

    return FutureBuilder<UserModel?>(
      future: getUserModel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          // Data is available, you can access the UserModel object through snapshot.data
          UserModel userModel = snapshot.data!;

          walletDisplay = userModel.wallet;
          // print('asdasd');
          // print(userModel
          //     .plateNumber); // Example usage: accessing the name property

          // TODO: Build your home page UI using the userModel object
          return Scaffold(
            appBar: AppBar(title: Text('NextSeed App')),
            bottomNavigationBar: SizedBox(
              height: 80,
              child: BottomNavigationBar(
                //Item Selection
                type: BottomNavigationBarType.fixed,
                backgroundColor: primaryColor,
                selectedItemColor: secondaryColor,
                unselectedItemColor: Colors.white,
                currentIndex: currentIndex,
                // onTap: (index) {
                //   setState(() {
                //     currentIndex = index;
                //   });
                // },
                //Item List
                items: [
                  BottomNavigationBarItem(
                    label: "Home",
                    icon: Icon(
                      Icons.home,
                      size: 30,
                    ),
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    label: "Community",
                    icon: Icon(
                      Icons.people_alt_rounded,
                      size: 30,
                    ),
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    label: "Car Info",
                    icon: Icon(
                      Icons.car_crash,
                      size: 30,
                    ),
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    label: "Profile",
                    icon: Icon(
                      Icons.person_rounded,
                      size: 30,
                    ),
                    backgroundColor: primaryColor,
                  ),
                ],
              ),
            ),
            body: StreamBuilder<List<DataModel>>(
              stream: RealtimeDatabaseService()
                  .getDataListStream(userModel.plateNumber),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataList = snapshot.data!;
                  if (dataList.isNotEmpty) {
                    if (lastUpdateRecord != '') {
                      if (dataList.first.details == 'OUT' &&
                          dataList.first.ref != lastUpdateRecord) {
                        print(dataList.first.ref);
                        print(lastUpdateRecord);
                        walletDisplay -= int.parse(dataList.first.fee);
                        userModel.updateUser(wallet: walletDisplay);
                      }
                    }
                    lastUpdateRecord = dataList.first.ref;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Color(0xFF0157C8),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 20,
                              child: GestureDetector(
                                onTap: () =>
                                    _signOut(context), // Pass the context
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  // Add profile image or initials here
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: IconButton(
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // Handle bell icon button press
                                },
                              ),
                            ),
                            Positioned(
                              top: 25,
                              right: 280,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userModel.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    userModel.plateNumber,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 100, left: 30, right: 30),
                              child: Container(
                                width: double.infinity,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Color(0xFF00BF63),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 35, top: 25, bottom: 10),
                                        child: Text(
                                          'E-Wallet Balance',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 35, bottom: 10),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 35,
                                              right: 35,
                                              top: 10,
                                              bottom: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Color(0xFF0157C8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'RM ${walletDisplay.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                    Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.account_balance_wallet,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Reload Now',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 33, bottom: 20),
                                  child: Text(
                                    'Our Services',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconContainer(
                                    icon: Icons.directions_car,
                                    text: 'Parking status',
                                  ),
                                  IconContainer(
                                    icon: Icons.security,
                                    text: 'Car secure',
                                  ),
                                  IconContainer(
                                    icon: Icons.payment,
                                    text: 'Pay now',
                                  ),
                                  IconContainer(
                                    icon: Icons.help_outline,
                                    text: 'Need help?',
                                  ),
                                ],
                              ),
                            ]),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 35, left: 35, bottom: 25),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Transaction History',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              DataModel data = dataList[index];
                              return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: data.details == 'IN'
                                        ? Colors.blue
                                        : Colors.green,
                                    radius: 10,
                                  ), // Add the icon to the left

                                  title: data.details == 'OUT'
                                      ? Text(
                                          'Payment: RM ${double.parse(data.fee).toStringAsFixed(2)}')
                                      : Text('Payment: - '),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Date: ${data.date}'),
                                      Text('Time: ${data.time}'),
                                    ],
                                  ),
                                  trailing: Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: data.details == 'IN'
                                            ? Colors.blue
                                            : Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        data.details,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                }
                return Container(); // Return an empty container
              },
            ),
          );
        } else if (snapshot.hasError) {
          // Error occurred while fetching UserModel
          print('Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          // Handle other cases
          return Text('No data available');
        }
      },
    );
  }
}
