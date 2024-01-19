import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';
import 'package:connectivity/connectivity.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:order_booking_shop/API/Globals.dart';
import 'package:order_booking_shop/Models/AttendanceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../API/DatabaseOutputs.dart';
import '../View_Models/AttendanceViewModel.dart';
import 'login.dart';
import 'OrderBookingStatus.dart';
import 'RecoveryFormPage.dart';
import 'ReturnFormPage.dart';
import 'ShopPage.dart';
import 'ShopVisit.dart';
import 'package:order_booking_shop/Databases/DBHelper.dart';

//tracker
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';
// import 'dart:js';
import 'package:flutter_background/flutter_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:gpx/gpx.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../API/Globals.dart';


//tarcker
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final myUid = userId;
final name = userNames;


bool showButton = false;


class MyIcons {
  static const IconData addShop = IconData(0xf52a, fontFamily: 'MaterialIcons');
  static const IconData store = Icons.store;
  static const IconData returnForm = IconData(0xee93, fontFamily: 'MaterialIcons');
  static const IconData person = Icons.person;
  static const IconData orderBookingStatus = IconData(0xf52a, fontFamily: 'MaterialIcons');
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  // await initializeService();
  runApp(MyApp());
}



//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   /// OPTIONAL, using custom notification channel id
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'my_foreground', // id
//     'MY FOREGROUND SERVICE', // title
//     description:
//     'This channel is used for important notifications.', // description
//     importance: Importance.low, // importance must be at low or higher level
//   );
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   if (Platform.isIOS || Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         iOS: DarwinInitializationSettings(),
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//   }
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,
//
//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,
//
//       notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'AWESOME SERVICE',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,
//
//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,
//
//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
// }
//
//
// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);
//
//   return true;
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();
//
//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually
//
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.setString("hello", "world");
//
//   /// OPTIONAL when use custom notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         // Update notification content with the current time
//         final updatedNotificationDetails = NotificationDetails(
//           android: AndroidNotificationDetails(
//             'my_foreground',
//             'MY FOREGROUND SERVICE',
//             icon: 'ic_bg_service_small',
//             ongoing: true,
//           ),
//         );
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         flutterLocalNotificationsPlugin.show(
//           888,
//           'COOL SERVICE',
//           'Awesome ${DateTime.now()}',
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'my_foreground',
//               'MY FOREGROUND SERVICE',
//               icon: 'ic_bg_service_small',
//               ongoing: true,
//             ),
//           ),
//         );
//
//         // if you don't using custom notification, uncomment this
//         service.setForegroundNotificationInfo(
//           title: "My App Service",
//           content: "Updated at ${DateTime.now()}",
//         );
//       }
//     }
//
//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//
//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }
//
//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }
//
//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>with WidgetsBindingObserver {
  final attendanceViewModel = Get.put(AttendanceViewModel());
  late TimeOfDay _currentTime; // Add this line
  late DateTime _currentDate;
  List<String> shopList = [];
  String? selectedShop2;
  int? attendanceId;
  late Isolate _isolate;
  int? attendanceId1;
  double? globalLatitude1;
  double? globalLongitude1;
  DBHelper dbHelper = DBHelper();

  //tracker
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  // Add a method to save the clock-in status to SharedPreferences
  // void _saveClockInStatus(bool isClockedIn) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isClockedIn', isClockedIn);
  // }

  Future<void> _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Clear the user ID or any other relevant data from SharedPreferences
    prefs.remove('userId');
    // Add any additional logout logic here
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      // Handle the case when permission is denied
      Fluttertoast.showToast(
        msg: "Location permissions are required to clock in.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  _loadClockStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isClockedIn = prefs.getBool('isClockedIn') ?? false;
    });
  }

  _saveClockStatus(bool clockedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isClockedIn', clockedIn);
    setState(() {
      isClockedIn = clockedIn;
    });
  }

  Future<void> _toggleClockInOut() async {
    final service = FlutterBackgroundService();
    Completer<void> completer = Completer<void>();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );


    bool isLocationEnabled = await _isLocationEnabled();

    if (!isLocationEnabled) {
      Fluttertoast.showToast(
        msg: "Please enable GPS or location services before clocking in.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      completer.complete();
      return completer.future;
    }

    bool isLocationPermissionGranted = await _checkLocationPermission();
    if (!isLocationPermissionGranted) {
      await _requestLocationPermission();
      completer.complete();
      return completer.future;
    }



    var id = await customAlphabet('1234567890', 10);
    await _getCurrentLocation();

    setState(() {
      isClockedIn = !isClockedIn;

      if (isClockedIn) {
        service.startService();

        attendanceViewModel.addAttendance(AttendanceModel(
          id: int.parse(id),
          timeIn: _getFormattedtime(),
          date: _getFormattedDate(),
          userId: userId.toString(),
          latIn: globalLatitude1,
          lngIn: globalLongitude1,
        ));

        _startTimer();
        _getLocation();
        _listenLocation();

        isClockedIn = true;

        DBHelper dbmaster = DBHelper();
        dbmaster.postAttendanceTable();

      } else {
        service.invoke("stopService");

        attendanceViewModel.addAttendanceOut(AttendanceOutModel(
          id: int.parse(id),
          timeOut: _getFormattedtime(),
          totalTime: _stopTimer(),
          date: _getFormattedDate(),
          userId: userId.toString(),
          latOut: globalLatitude1,
          lngOut: globalLongitude1,
        ));
        isClockedIn = false;
        DBHelper dbmaster = DBHelper();
        dbmaster.postAttendanceOutTable();
        _stopTimer();
        setState(() async {
          _stopListening();
          await saveGPXFile();
          await postFile();
        });
      }
    });

    // Wait for 10 seconds
    await Future.delayed(Duration(seconds: 3));

    Navigator.pop(context); // Close the loading indicator dialog

    completer.complete();
    return completer.future;
  }


  Future<bool> _isLocationEnabled() async {
    // Add your logic to check if location services are enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    return isLocationEnabled;
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'clock_channel', // id
      'Clock Notifications', // title
      description: 'Notifications for clock events', // description
      importance: Importance.high, // importance must be at high or max level
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'clock_channel', // channel_id
      'Clock Notifications', // channel_name
      //: 'Notifications for clock events',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      title,
      body,
      platformChannelSpecifics,
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    fetchShopList();
    _loadClockStatus();

    _currentDate = DateTime.now(); // Initialize _currentDate
    _currentTime = TimeOfDay.now();
    _initializeDateTime(); // Initialize both date and time
    //trac
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    if(isClockedIn){
      _clockrefresh();
    }
    _getFormattedDate();
    // _getFormattedTime();

  }
  String _getFormattedtime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm:ss a');
    return formatter.format(now);
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    _currentDate = now;
    _currentTime = TimeOfDay.fromDateTime(now);
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsPassed++;
      });
    });
  }

  void _clockrefresh(){
    timer = Timer.periodic(Duration(seconds: 0), (timer) {
      setState(() {

      });
    });
  }

  String _stopTimer() {
    timer.cancel();
    String totalTime = _formatDuration(secondsPassed.toString());
    setState(() {
      secondsPassed = 0;
    });
    return totalTime;
  }



  String _formatDuration(String secondsString) {
    int seconds = int.parse(secondsString);
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String secondsFormatted = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$secondsFormatted';
  }


  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     if (_isClockedIn) {
  //       _startTimer();
  //     }
  //   } else {
  //     _stopTimer();
  //   }
  // }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      // Save the location into the database (you need to implement this part)
      globalLatitude1 = position.latitude;
      globalLongitude1 = position.longitude;
      // Show a toast
      Fluttertoast.showToast(
        msg: 'Location captured!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Error getting current location: $e');
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      throw Exception('Location services are disabled.');
    }

    // Check the location permission status.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied
      throw Exception('Location permissions are permanently denied.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchShopList() async {
    List<String> fetchShopList = await fetchData();
    if (fetchShopList.isNotEmpty) {
      setState(() {
        shopList = fetchShopList;
        selectedShop2 = shopList.first;
      });
    }
  }

  Future<List<String>> fetchData() async {
    return [];
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(now);
  }


  void handleShopChange(String? newShop) {
    setState(() {
      selectedShop2 = newShop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          toolbarHeight: 80.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Timer: ${_formatDuration(secondsPassed.toString())}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<int>(
                icon: Icon(Icons.more_vert),
                color: Colors.white,
                onSelected: (value) async {
                  switch (value) {
                    case 1:
                      await backgroundTask();
                      await postFile();



                      DatabaseOutputs outputs = DatabaseOutputs();
                      outputs.initializeData();
                      // Show a loading indicator for 4 seconds
                      showLoadingIndicator(context);
                      await Future.delayed(Duration(seconds: 10));

                      // After 4 seconds, hide the loading indicator and perform the refresh logic
                      Navigator.of(context, rootNavigator: true).pop();
                      // Pop the loading dialog
                      // Add your logic for refreshing here
                      break;

                    case 2:
                    // Handle the action for the second menu item (Log Out)
                      if (isClockedIn) {
                        // Check if the user is clocked in
                        Fluttertoast.showToast(
                          msg: "Please clock out before logging out.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        exit(0);
                        await _logOut(); // Call the function to log out

                        // If the user is not clocked in, proceed with logging out
                        Navigator.pushReplacement(
                          // Replace the current page with the login page
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginForm(),
                          ),
                        );
                      }
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text('Refresh'),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text('Log Out'),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),

            child: Center(

              child: Column(


                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          height: 150,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isClockedIn) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopPage(),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Clock In Required'),
                                    content: Text('Turn on location.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MyIcons.addShop,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text('Add Shop'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                          ],
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 150,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isClockedIn) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopVisit(onBrandItemsSelected: (String) {}),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Clock In Required'),
                                    content: Text('Please clock in before visiting a shop.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.store,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text('Shop Visit'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isClockedIn) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ReturnFormPage()));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Clock In Required'),
                                    content: Text('Please clock in before accessing the Return Form.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MyIcons.returnForm,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text('Return Form'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 150,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isClockedIn) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RecoveryFromPage()));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Clock In Required'),
                                    content: Text('Please clock in before accessing the Recovery.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text('Recovery'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isClockedIn) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderBookingStatus(),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Clock In Required'),
                                    content: Text('Please clock in before checking Order Booking Status.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MyIcons.orderBookingStatus,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text('Order Booking Status'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: isClockedIn
                              ? null
                              : () async {

                            Completer<void> completer = Completer<void>();

                            showDialog(
                              context: context,
                              barrierDismissible: false, // Prevent users from dismissing the dialog
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );


                            bool isLocationEnabled = await _isLocationEnabled();

                            if (!isLocationEnabled) {
                              Fluttertoast.showToast(
                                msg: "Please enable GPS or location services before clocking in.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              completer.complete();
                              return completer.future;
                            }
                            await showNotification('Clock In', 'You have clocked in.');

                            bool isLocationPermissionGranted = await _checkLocationPermission();
                            if (!isLocationPermissionGranted) {
                              await _requestLocationPermission();
                              completer.complete();
                              return completer.future;
                            }

                            var id = await customAlphabet('1234567890', 10);
                            await _getCurrentLocation();

                            final service = FlutterBackgroundService();

                            service.startService();

                            attendanceViewModel.addAttendance(AttendanceModel(
                              id: int.parse(id),
                              timeIn: _getFormattedtime(),
                              date: _getFormattedDate(),
                              userId: userId.toString(),
                              latIn: globalLatitude1,
                              lngIn: globalLongitude1,
                            ));

                            _startTimer();
                            _getLocation();
                            _listenLocation();

                            isClockedIn = true;

                            DBHelper dbmaster = DBHelper();
                            dbmaster.postAttendanceTable();
                            _saveClockStatus(true);
                            print('Clock In Pressed!');
                          },
                          child: Text('Clock In'),
                        ),
                        SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: isClockedIn
                              ? () async {

                            await showNotification('Clock Out', 'You have clocked out.');

                            var id = await customAlphabet('1234567890', 10);

                            final service = FlutterBackgroundService();

                            _saveClockStatus(false);
                            service.invoke("stopService");

                            attendanceViewModel.addAttendanceOut(AttendanceOutModel(
                              id: int.parse(id),
                              timeOut: _getFormattedtime(),
                              totalTime: _stopTimer(),
                              date: _getFormattedDate(),
                              userId: userId.toString(),
                              latOut: globalLatitude1,
                              lngOut: globalLongitude1,
                            ));
                            isClockedIn = false;
                            DBHelper dbmaster = DBHelper();
                            dbmaster.postAttendanceOutTable();
                            _stopTimer();
                            setState(() async {
                              _stopListening();
                              await saveGPXFile();
                              await postFile();
                            });
                            //Wait for 10 seconds
                            //   await Future.delayed(Duration(seconds: 3));
                            //
                            //   Navigator.pop(context); // Close the loading indicator dialog
                            //
                            //   completer.complete();
                            //   return completer.future;
                            // }
                            print('Clock Out Pressed!');
                          }
                              : null,
                          child: Text('Clock Out'),
                        ),
                      ],
                    ),


                  ]
              ),
            ),
          ),
        ),
        //
        // floatingActionButton: Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom: 20.0),
        //
        //     child:ElevatedButton.icon(
        //       onPressed:() async {
        //        // await MoveToBackground.moveTaskToBack();
        //         final service = FlutterBackgroundService();
        //         await _toggleClockInOut();
        //         },
        //       icon: Icon(
        //         isClockedIn ? Icons.timer_off : Icons.timer,
        //         color: isClockedIn ? Colors.red : Colors.green,
        //       ),
        //       label: Text(
        //         isClockedIn ? 'Clock Out' : 'Clock In',
        //         style: TextStyle(fontSize: 14),
        //       ),
        //       style: ElevatedButton.styleFrom(
        //         primary: Colors.white,
        //         onPrimary: isClockedIn ? Colors.red : Colors.green,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //       ),
        //     ),
        //
        //   ),
        // ),
      ),
    );
  }

  var gpx;
  // Create a track
  var track;
  // Create a track segment
  var segment;
  var trkpt;
  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(myUid).set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': name.toString(),
        'isActive': false
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    gpx = new Gpx();
    track = new Trk();
    segment = new Trkseg();

    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc(myUid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': name.toString(),
        'isActive':true
      }, SetOptions(merge: true));

      // Create a track point with latitude, longitude, and time information
      final trackPoint = Wpt(
        lat: currentlocation.latitude,
        lon: currentlocation.longitude,
        time: DateTime.now(),
      );

      segment.trkpts.add(trackPoint);

      if (track.trksegs.isEmpty) {
        track.trksegs.add(segment);
        gpx.trks.add(track);
      }

      final gpxString = GpxWriter().asString(gpx, pretty: true);
      print("XXX $gpxString");
    });
  }
  Future<void> saveGPXFile() async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final gpxString = await GpxWriter().asString(gpx, pretty: true);
    final downloadDirectory = await getDownloadsDirectory();
    final filePath = "${downloadDirectory!.path}/track$date.gpx";
    final file = File(filePath);

    if (await file.exists()) {
      final existingGpx = await GpxReader().fromString(await file.readAsString());
      final newSegment = GpxReader().fromString(gpxString); // Replace this with the actual segment you want to add
      existingGpx.trks[0].trksegs.add(newSegment.trks[0].trksegs[0]);
      await file.writeAsString(GpxWriter().asString(existingGpx, pretty: true));
    } else {
      await file.writeAsString(gpxString);
    }

    print('GPX file saved successfully at ${file.path}');
    Fluttertoast.showToast(
      msg: "GPX file saved in the Downloads folder!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  Future<void> GPXinfo() async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final downloadDirectory = await getDownloadsDirectory();
    final filePath = "${downloadDirectory!.path}/track$date.gpx";

    final file = File(filePath);
    print("XXX    DATA    ${file.readAsStringSync()}");
  }

  Future<void> postFile() async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final downloadDirectory = await getDownloadsDirectory();
    //final directory = await getApplicationDocumentsDirectory();
    final filePath = File('${downloadDirectory?.path}/track$date.gpx');

    if (!filePath.existsSync()) {
      print('File does not exist');
      return;
    }
    var request = http.MultipartRequest("POST",
        Uri.parse("https://apex.oracle.com/pls/apex/metaxperts/location/post/"));
    var gpxFile = await http.MultipartFile.fromPath(
        'body', filePath.path);
    request.files.add(gpxFile);
    // Add other fields if needed
    request.fields['userId'] = userId;
    request.fields['userName'] = userNames;
    request.fields['fileName'] = "${_getFormattedDate()}.gpx";
    request.fields['date'] = _getFormattedDate();
    print(userNames);
    // request.fields['currentTime']=

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = String.fromCharCodes(responseData);
        print("Results: Post Successfully");
        //deleteGPXFile(); // Delete the GPX file after successful upload
        _deleteDocument();
      } else {
        print("Failed to upload file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future<void> deleteGPXFile() async {
  //   try {
  //     final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  //    // final gpxString = await GpxWriter().asString(gpx, pretty: true);
  //     final downloadDirectory = await getDownloadsDirectory();
  //     final filePath = "${downloadDirectory!.path}/track$date.gpx";
  //     final file = File(filePath);
  //
  //     if (file.existsSync()) {
  //       await file.delete();
  //       print('GPX file deleted successfully');
  //     } else {
  //       print('GPX file does not exist');
  //     }
  //   } catch (e) {
  //     print('Error deleting GPX file: $e');
  //   }
  // }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }
  void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Refreshing..."),
            ],
          ),
        );
      },
    );
  }

  Future<bool> isInternetConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    print('Internet Connected: $isConnected');

    return isConnected;
  }

  Future<void> backgroundTask() async {
    try {
      bool isConnected = await isInternetConnected();

      if (isConnected) {
        print('Internet connection is available. Initiating background data synchronization.');
        await synchronizeData();
        print('Background data synchronization completed.');
      } else {
        print('No internet connection available. Skipping background data synchronization.');
      }
    } catch (e) {
      print('Error in backgroundTask: $e');
    }
  }

  Future<void> synchronizeData() async {
    print('Synchronizing data in the background.');

    await postAttendanceTable();
    await postAttendanceOutTable();
    await postShopTable();
    await postShopVisitData();
    await postStockCheckItems();
    await postMasterTable();
    await postOrderDetails();
    await postReturnFormTable();
    await postReturnFormDetails();
    await postRecoveryFormTable();
  }

  Future<void> postShopVisitData() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postShopVisitData();
  }

  Future<void> postStockCheckItems() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postStockCheckItems();
  }

  Future<void> postAttendanceOutTable() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postAttendanceOutTable();
  }

  Future<void> postAttendanceTable() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postAttendanceTable();
  }

  Future<void> postMasterTable() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postMasterTable();
  }

  Future<void> postOrderDetails() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postOrderDetails();
  }

  Future<void> postShopTable() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postShopTable();
  }

  Future<void> postReturnFormTable() async {
    print('Attempting to post Return data');
    DBHelper dbHelper = DBHelper();
    await dbHelper.postReturnFormTable();
    print('Return data posted successfully');
  }

  Future<void> postReturnFormDetails() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postReturnFormDetails();
  }

  Future<void> postRecoveryFormTable() async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.postRecoveryFormTable();
  }


  //delete document
  _deleteDocument() async {
    await FirebaseFirestore.instance
        .collection('location')
        .doc(myUid)
        .delete()
        .then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
  }
  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}