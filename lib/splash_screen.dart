import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/constants/remote_on.dart';
import 'package:gocut_vendor/global/data.dart';
import 'package:gocut_vendor/intro/into-screen.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/auth/login.dart';
import 'package:gocut_vendor/lib/view/auth/otp-verification.dart';
import 'package:gocut_vendor/lib/view/auth/sign-up.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/mainsection.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'localNotifications.dart';

final FirebaseRemoteConfig remoteConfigVar = FirebaseRemoteConfig.instance;

bool showDetail = false;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isBaseUrlLoaded = false; // Flag to track if BASE_URL is loaded

  @override
  void initState() {
    super.initState();
    statemanagement();
    fcmtoken();
    getPolociessssss();

    LocalNotification.initialize();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });

    Future.delayed(Duration(seconds: 2), () {
      if (accessToken != "") {
        getStatus();
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
          (route) => false,
        );
      }
    });

    // _initConfig();
  }

  Future getStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/auth/isverifiedORregsietered'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      // success(mesg: decodedMap['message'], context: context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainSection()),
        (route) => false,
      );

      // /*

      //      decodedMapp['Vendor'][''] == true
      // ? Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MainSection()),
      //     (route) => false,
      //   )
      // : Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Sign_Up(
      //         mobile: widget.mobile,
      //       ),
      //     ),
      //   );
    } else if (response.statusCode == 405) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print("get all verifications${decodedMap}");
      // failed(mesg: decodedMap['message'], context: context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_Up(
            mobile: decodedMap['mobileNumber'].toString(),
          ),
        ),
      );
    } else if (response.statusCode == 403) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (context) => false,
      );
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (context) {
      //       return MyAlertDialog();
      //     });
      // var responseString = await response.stream.bytesToString();
      //   final decodedMap = json.decode(responseString);

      //   failed(mesg: decodedMap['message'], context: context);
      //   Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                               builder: (context) => Sign_Up(
      //                                 mobile: widget.mobile,
      //                               ),
      //                             ),
      //                           );
    } else {
      print(response.reasonPhrase);
    }
  }

  // Future<void> _initConfig() async {
  //   await _fetchConfig();

  //   // Once _fetchConfig() completes and BASE_URL is loaded, initiate other functions
  //   if (isBaseUrlLoaded) {
  //     fcmtoken();
  //     getPolociessssss();
  //     statemanagement();
  //     // Future.delayed(Duration(seconds: 1), () {
  //     //   getStatus();
  //     // });
  //   }
  // }

  // Future<void> _fetchConfig() async {
  //   await remoteConfigVar.fetchAndActivate();
  //   setState(() {
  //     BASE_URL = MyConst.apiBase;
  //     IMAGE_BASE_URL = MyConst.imageBase;
  //   });

  //   // Check if BASE_URL is still empty, retry fetching if needed
  //   if (BASE_URL.isEmpty) {
  //     await Future.delayed(Duration(seconds: 1)); // Adjust delay as needed
  //     await _fetchConfig(); // Retry fetching
  //   } else {
  //     statemanagement();
  //   }

  //   print("Here--------->      " + BASE_URL + "    " + IMAGE_BASE_URL);
  // }

  // Future<void> getStatus() async {
  //   if (!isBaseUrlLoaded) return; // Exit early if BASE_URL is not loaded

  //   var headers = {'Authorization': 'Bearer $accessToken'};
  //   var request = http.Request(
  //       'POST', Uri.parse('$BASE_URL/vendor/auth/isverifiedORregsietered'));

  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var responseString = await response.stream.bytesToString();
  //     final decodedMap = json.decode(responseString);

  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => MainSection()),
  //       (route) => false,
  //     );
  //   } else if (response.statusCode == 405) {
  //     var responseString = await response.stream.bytesToString();
  //     final decodedMap = json.decode(responseString);

  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Sign_Up(
  //           mobile: decodedMap['mobileNumber'].toString(),
  //         ),
  //       ),
  //     );
  //   } else if (response.statusCode == 403) {
  //     setState(() {
  //       showDetail = true;
  //     });
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return MyAlertDialog();
  //       },
  //     );
  //   } else {
  //     print(response.statusCode.toString() + "Here");
  //   }
  // }

  getPolociessssss() {
    if (!isBaseUrlLoaded) return; // Exit early if BASE_URL is not loaded
    get_policies(context, (response) {
      setState(() {
        policies = response['policies'];
      });

      print("the policeis : ${policies}");
    });
  }

  void statemanagement() async {
    SharedPreferences getmaintoken = await SharedPreferences.getInstance();

    String? maintoken = getmaintoken.getString('mainToken');

    setState(() {
      accessToken = maintoken!;
    });

    print("Access Token : ${accessToken}");
  }

  // void fcmtoken() async {
  //   if (!isBaseUrlLoaded) return; // Exit early if BASE_URL is not loaded

  //   String? fcmtokenss = await FirebaseMessaging.instance.getToken();

  //   setState(() {
  //     fcmToken = fcmtokenss!;
  //   });
  // }

  fcmtoken() async {
    // Request permission for notifications
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();

    // Check if permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print("User granted permission");
      // AppLoaders.showLoading(
      //     context: context,
      //     note: 'Please wait while we are working on your request.');

      // Retrieve the FCM token
      String? fcmtoken = await FirebaseMessaging.instance.getToken();

      if (fcmtoken != null) {
        // Get.back();
        print("FCM TOKEN : $fcmtoken");

        setState(() {
          fcmToken = fcmtoken!;
        });

        // Update the state with the FCM token
      } else {
        print("Failed to get FCM token");
      }
    } else {
      print("User declined or has not accepted permission");
    }
  }

  // void fcmtoken() async {
  //   // Request permission for notifications
  //   NotificationSettings settings =
  //       await FirebaseMessaging.instance.requestPermission();

  //   // Check if permission is granted
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print("User granted permission");

  //     // Retrieve the FCM token
  //     String? fcmtoken = await FirebaseMessaging.instance.getToken();

  //     if (fcmtoken != null) {
  //       print("FCM TOKEN : $fcmtoken");

  //       setState(() {
  //         fcmToken = fcmtoken!;
  //       });
  //     } else {
  //       print("Failed to get FCM token");
  //     }
  //   } else {
  //     print("User declined or has not accepted permission");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // getStatus();
                  },
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Text(
                //   'Allude',
                //   style: TextStyle(color: pink, fontFamily: 'PopS', fontSize: 18),
                // )
              ],
            ),
          ),
        ),
        showDetail != true
            ? SizedBox()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "Your profile is still under verification process. Please wait till the process gets completed.",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
      ],
    );
  }
}

// class LocationHomeScreen extends StatefulWidget {
//   @override
//   _LocationHomeScreenState createState() => _LocationHomeScreenState();
// }

// class _LocationHomeScreenState extends State<LocationHomeScreen> {
//   // String address = "1600 Amphitheatre Parkway, Mountain View, CA";
//   String address = "Satyanarayana methai bhandar, begum bazar, hyderabad";
//   double? latitude;
//   double? longitude;
//   late GoogleMapController mapController;

//   @override
//   void initState() {
//     super.initState();
//     _getCoordinates();
//   }

//   Future<void> _getCoordinates() async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       setState(() {
//         latitude = locations.first.latitude;
//         longitude = locations.first.longitude;
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Geocoding Example"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 _getCoordinates();
//               },
//               icon: Icon(Icons.history))
//         ],
//       ),
//       body: Center(
//         child: latitude == null || longitude == null
//             ? CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Latitude: $latitude, Longitude: $longitude"),
//                   SizedBox(height: 20),
//                   Container(
//                     height: 250,
//                     width: double.infinity,
//                     child: GoogleMap(
//                       onMapCreated: _onMapCreated,
//                       initialCameraPosition: CameraPosition(
//                         target: LatLng(latitude!, longitude!),
//                         zoom: 15.0,
//                       ),
//                       markers: {
//                         Marker(
//                           markerId: MarkerId('locationMarker'),
//                           position: LatLng(latitude!, longitude!),
//                         ),
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
// }
