import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Globals.dart';
import '../Views/HomePage.dart';

var gpx;
// Create a track
var track;
// Create a track segment
var segment;
var trkpt;
var long,lat;

String gpxString="";
StreamSubscription<Position>? _positionStreamSubscription;

// Future<void> listenLocation() async {
//   print("W100 Start");
//   gpx = new Gpx();
//   track = new Trk();
//   segment = new Trkseg();
//
//   _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) async {
//     await FirebaseFirestore.instance.collection('location').doc(myUid).set({
//       'latitude': position.latitude,
//       'longitude': position.longitude,
//       'name': name.toString(),
//       'isActive': true
//     }, SetOptions(merge: true));
//
//     // Create a track point with latitude, longitude, and time information
//     final trackPoint = Wpt(
//       lat: position.latitude,
//       lon: position.longitude,
//       time: DateTime.now(),
//     );
//
//     segment.trkpts.add(trackPoint);
//
//     if (track.trksegs.isEmpty) {
//       track.trksegs.add(segment);
//       gpx.trks.add(track);
//     }
//
//     gpxString = GpxWriter().asString(gpx, pretty: true);
//     print("W100 $gpxString");
//   });
//   print("W100 END");
// }
Timer? _timer;
Future<void> listenLocation() async {
  Firebase.initializeApp();
  //String uid = FirebaseAuth.instance.currentUser!.uid;
  gpx = new Gpx();
  track = new Trk();
  segment = new Trkseg();
  print("W100 Start");
  _timer =  Timer.periodic(Duration(seconds: 3), (timer) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    print("W100 Repeat");
    await FirebaseFirestore.instance.collection('location').doc("iqra").set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'name': name.toString(),
      'isActive': true
    }, SetOptions(merge: true));
    long = position.longitude.toString();
    lat = position.latitude.toString();
    // Create a track point with latitude, longitude, and time information
    final trackPoint = Wpt(
      lat: position.latitude,
      lon: position.longitude,
      time: DateTime.now(),
    );

    segment.trkpts.add(trackPoint);

    if (track.trksegs.isEmpty) {
      track.trksegs.add(segment);
      gpx.trks.add(track);
    }

    gpxString = GpxWriter().asString(gpx, pretty: true);
    print("W100 $gpxString");
  });
  print("W100 END");
}


Future<void> saveGPXFile() async {
  try{
    print(" q100 start svae GPX");
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final gpxString = await GpxWriter().asString(gpx, pretty: true);
    final downloadDirectory = await getDownloadsDirectory();
    final filePath = "${downloadDirectory!.path}/track$date.gpx";
    final file = File(filePath);
    print("q100 Mid svae GPX");
    if (await file.exists()) {
      print("q100 File Exist 1");
      var newSegment = GpxReader().fromString(gpxString);
      print("q100 File Exist 2");
      var existingGpx = await GpxReader().fromString(await file.readAsString());
      print("q100 File Exist 3");
      existingGpx.trks[0].trksegs.add(newSegment.trks[0].trksegs[0]);
      print("q100 File Exist 4");
      await file.writeAsString(GpxWriter().asString(existingGpx, pretty: true));
      print("q100 File Exist 5");
    } else {
      print("q100 File not Exist");
      await file.writeAsString(gpxString);
    }
    print('q100 GPX file saved successfully at ${file.path}');
  } on Exception catch (e) {
    print("Q100 $e");
  }


  // Fluttertoast.showToast(
  //   msg: "GPX file saved in the Downloads folder!",
  //   toastLength: Toast.LENGTH_SHORT,
  //   gravity: ToastGravity.BOTTOM,
  //   backgroundColor: Colors.green,
  //   textColor: Colors.white,
  // );
}




Future<void> EndAllServicesLocation() async {
  stopListeningLocation();
  await saveGPXFile();
}

void stopListeningLocation() {
  _timer?.cancel();
  _timer = null;
  print("Stopped listening to location updates");
}

  getLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition();
      await FirebaseFirestore.instance.collection('location').doc(myUid).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'name': name.toString(),
        'isActive': false
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

Future<void> startTimer() async {
  startTimerFromSavedTime();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Timer.periodic(Duration(seconds: 1), (timer) async {
    secondsPassed++;
    await prefs.setInt('secondsPassed', secondsPassed);
  });
}

void startTimerFromSavedTime() {
  SharedPreferences.getInstance().then((prefs) async {
    String savedTime = prefs.getString('savedTime') ?? '00:00:00';
    List<String> timeComponents = savedTime.split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);
    int seconds = int.parse(timeComponents[2]);
    int totalSavedSeconds = hours * 3600 + minutes * 60 + seconds;
    final now = DateTime.now();
    int totalCurrentSeconds = now.hour * 3600 + now.minute * 60 + now.second;
    secondsPassed = totalCurrentSeconds - totalSavedSeconds;
    if (secondsPassed < 0) {
      secondsPassed = 0;
    }
    await prefs.setInt('secondsPassed', secondsPassed);
    print("Loaded Saved Time");
  });
}
