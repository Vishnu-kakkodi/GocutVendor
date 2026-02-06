// import 'dart:convert';
// import 'package:bounce/bounce.dart';
// import 'package:double_back_to_close_app/double_back_to_close_app.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:gocut_vendor/lib/controllers/bottomNavigation_controller.dart';
// import 'package:gocut_vendor/main.dart';
// import 'package:http/http.dart' as http;
// import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
// import 'package:gocut_vendor/color/colors.dart';
// import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
// import 'package:gocut_vendor/lib/globals/mapss_data.dart';
// import 'package:gocut_vendor/lib/view/mainsection/Profile/profile.dart';
// import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
// import 'package:gocut_vendor/lib/view/mainsection/home/home.dart';
// import 'package:gocut_vendor/lib/view/mainsection/menu/menu.dart';
// import 'package:gocut_vendor/repo/repos.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';

// // int _bottomNavigationController.selectedIndex = 0;
// bool storSta = false;
// bool storeStatusss = false;

// class MainSection extends StatefulWidget {
//   const MainSection({super.key});

//   @override
//   State<MainSection> createState() => _MainSectionState();
// }

// class _MainSectionState extends State<MainSection> {
//   int? _lastBackPressedTime;

//   @override
//   void initState() {
//     super.initState();
//     // TODO: implement initState
//     Future.delayed(Duration(seconds: 1), () {
//       requestPermissions();
//     });
//     get_profile(context, (response) {
//       setState(() {
//         vendor_data = response['vendorProfile'];
//       });

//       get_salon(context, (response) {
//         setState(() {
//           salon = response['salonprofile'];
//         });
//         // print("the salon dat : ${salon}");
//       });
//     });

//     get_policies(context, (response) {
//       setState(() {
//         policies = response['policies'];
//       });

//       print("the policeis : ${policies}");
//     });
//     getStoreStatus();
//   }

//   Future<void> requestPermissions() async {
//     // Function to request a single permission and handle denial
//     Future<void> requestPermission(Permission permission) async {
//       while (await permission.isDenied) {
//         final status = await permission.request();
//         if (status.isDenied) {
//           // You can show a dialog here if needed to explain why the permission is necessary
//           print("${permission.toString()} is denied");
//         }
//       }
//     }

//     // Request all relevant permissions
//     await requestPermission(Permission.camera);
//     await requestPermission(Permission.location);
//     await requestPermission(Permission.notification);
//   }

//   Future getStoreStatus() async {
//     var headers = {'Authorization': 'Bearer $accessToken'};
//     var request = http.Request(
//         'POST', Uri.parse('$BASE_URL/vendor/salon/getsalonstorestatus'));

//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();
//       final decodedMap = json.decode(responseString);

//       setState(() {
//         storSta = decodedMap['store_status'];
//       });
//     } else {
//       print(response.reasonPhrase);
//     }
//   }

//   final _bottomNavigationController = Get.find<BottomNavigationController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // key: scaffoldKey,
//       body: Obx(() {
//         return _bottomNavigationController.selectedIndex == 0
//             ? HomeScreen()
//             : _bottomNavigationController.selectedIndex == 1
//                 ? BookingsScreen()
//                 : _bottomNavigationController.selectedIndex == 2
//                     ? MenuScreen(
//                         type: 'mainsection',
//                       )
//                     : ProfileScreen();
//       }),

//       bottomNavigationBar: Obx(() {
//         return Container(
//           color: white,
//           height: 80,
//           child: BottomAppBar(
//             surfaceTintColor: white,
//             color: white,
//             elevation: 1,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Bounce(
//                     scaleFactor: 1.3,
//                     onTap: () {
//                       _bottomNavigationController.updateSelectedIndex(0);
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ImageIcon(
//                           AssetImage(
//                             'assets/images/home.png',
//                           ),
//                           size: 28,
//                           color: _bottomNavigationController.selectedIndex == 0
//                               ? primaryColor
//                               : null,
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "Home",
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             color:
//                                 _bottomNavigationController.selectedIndex == 0
//                                     ? primaryColor
//                                     : black,
//                             fontWeight:
//                                 _bottomNavigationController.selectedIndex == 0
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         _bottomNavigationController.selectedIndex != 0
//                             ? SizedBox()
//                             : Container(
//                                 height: 2,
//                                 width: 20,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(90),
//                                     color: primaryColor),
//                               )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Bounce(
//                     scaleFactor: 1.3,
//                     onTap: () {
//                       _bottomNavigationController.updateSelectedIndex(1);
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ImageIcon(
//                           AssetImage(
//                             'assets/images/list.png',
//                           ),
//                           size: 28,
//                           color: _bottomNavigationController.selectedIndex == 1
//                               ? primaryColor
//                               : Colors.black,
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "Bookings",
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             color:
//                                 _bottomNavigationController.selectedIndex == 1
//                                     ? primaryColor
//                                     : black,
//                             fontWeight:
//                                 _bottomNavigationController.selectedIndex == 1
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         _bottomNavigationController.selectedIndex != 1
//                             ? SizedBox()
//                             : AnimatedContainer(
//                                 duration: Duration(milliseconds: 300),
//                                 height: 2,
//                                 width: 20,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(90),
//                                     color: primaryColor),
//                               )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Bounce(
//                     scaleFactor: 1.3,
//                     onTap: () {
//                       _bottomNavigationController.updateSelectedIndex(2);
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ImageIcon(
//                           AssetImage(
//                             'assets/images/ep_menu.png',
//                           ),
//                           size: 28,
//                           color: _bottomNavigationController.selectedIndex == 2
//                               ? primaryColor
//                               : null,
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "My Menu",
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             color:
//                                 _bottomNavigationController.selectedIndex == 2
//                                     ? primaryColor
//                                     : black,
//                             fontWeight:
//                                 _bottomNavigationController.selectedIndex == 2
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         _bottomNavigationController.selectedIndex != 2
//                             ? SizedBox()
//                             : AnimatedContainer(
//                                 duration: Duration(milliseconds: 300),
//                                 height: 2,
//                                 width: 20,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(90),
//                                     color: primaryColor),
//                               )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Bounce(
//                     scaleFactor: 1.3,
//                     onTap: () {
//                       _bottomNavigationController.updateSelectedIndex(3);
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         ImageIcon(
//                           AssetImage(
//                             'assets/images/profile-fill.png',
//                           ),
//                           size: 28,
//                           color: _bottomNavigationController.selectedIndex == 3
//                               ? primaryColor
//                               : null,
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "Profile",
//                           style: GoogleFonts.poppins(
//                             fontSize: 10,
//                             color:
//                                 _bottomNavigationController.selectedIndex == 3
//                                     ? primaryColor
//                                     : black,
//                             fontWeight:
//                                 _bottomNavigationController.selectedIndex == 3
//                                     ? FontWeight.w600
//                                     : FontWeight.w400,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 3,
//                         ),
//                         _bottomNavigationController.selectedIndex != 3
//                             ? SizedBox()
//                             : AnimatedContainer(
//                                 duration: Duration(milliseconds: 300),
//                                 height: 2,
//                                 width: 20,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(90),
//                                     color: primaryColor),
//                               )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// // Future<void> showNotification() async {
// //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
// //     'go cut', //id
// //     'High Importance Notification', //title
// //     importance: Importance.max,
// //     priority: Priority.high,
// //   );

// //   var platformChannelSpecifics =
// //       NotificationDetails(android: androidPlatformChannelSpecifics, iOS: null);
// //   await flutterLocalNotificationsPlugin.show(
// //     0,
// //     'Hello',
// //     'Click to see message',
// //     platformChannelSpecifics,
// //     payload: 'Hello User',
// //   );
// // }

// Future<bool?> showExitDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         backgroundColor: Colors.white,
//         title: Row(
//           children: [
//             Icon(Icons.exit_to_app, color: Color(0xFF63183F)),
//             SizedBox(width: 8),
//             Text(
//               'Exit App',
//               style: TextStyle(
//                   color: Color(0xFF63183F), fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to exit the app?',
//           style: TextStyle(fontSize: 16, color: Colors.black87),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                   color: Color(0xFF63183F), fontWeight: FontWeight.bold),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF63183F),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text(
//               'Exit',
//               style: TextStyle(color: white),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }






















import 'dart:convert';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gocut_vendor/lib/controllers/bottomNavigation_controller.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/profile.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/home.dart';
import 'package:gocut_vendor/lib/view/mainsection/menu/menu.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

bool storSta = false;

class MainSection extends StatefulWidget {
  const MainSection({super.key});

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  final _bottomNavigationController = Get.find<BottomNavigationController>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      requestPermissions();
    });

    get_profile(context, (response) {
      setState(() {
        vendor_data = response['vendorProfile'];
      });

      get_salon(context, (response) {
        setState(() {
          salon = response['salonprofile'];
        });
      });
    });

    get_policies(context, (response) {
      setState(() {
        policies = response['policies'];
      });
    });

    getStoreStatus();
  }

  Future<void> requestPermissions() async {
    Future<void> ask(Permission permission) async {
      if (await permission.isDenied) {
        await permission.request();
      }
    }

    await ask(Permission.camera);
    await ask(Permission.location);
    await ask(Permission.notification);
  }

  Future getStoreStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
      'POST',
      Uri.parse('$BASE_URL/vendor/salon/getsalonstorestatus'),
    );

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final decodedMap =
          json.decode(await response.stream.bytesToString());
      setState(() {
        storSta = decodedMap['store_status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _bottomNavigationController.selectedIndex == 0
            ? const HomeScreen()
            : _bottomNavigationController.selectedIndex == 1
                ? const BookingsScreen()
                : _bottomNavigationController.selectedIndex == 2
                    ?  MenuScreen(type: 'mainsection')
                    : const ProfileScreen();
      }),

      /// ✅ ONLY FIX IS HERE
      bottomNavigationBar: Obx(() {
        return SafeArea(
          top: false,
          child: Container(
            color: white,
            child: BottomAppBar(
              surfaceTintColor: white,
              color: white,
              elevation: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Bounce(
                      scaleFactor: 1.3,
                      onTap: () {
                        _bottomNavigationController.updateSelectedIndex(0);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // ✅ FIX
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(
                            const AssetImage('assets/images/home.png'),
                            size: 28,
                            color:
                                _bottomNavigationController.selectedIndex == 0
                                    ? primaryColor
                                    : null,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Home",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color:
                                  _bottomNavigationController.selectedIndex ==
                                          0
                                      ? primaryColor
                                      : black,
                              fontWeight:
                                  _bottomNavigationController.selectedIndex ==
                                          0
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 3),
                          _bottomNavigationController.selectedIndex != 0
                              ? const SizedBox()
                              : Container(
                                  height: 2,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(90),
                                    color: primaryColor,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Bounce(
                      scaleFactor: 1.3,
                      onTap: () {
                        _bottomNavigationController.updateSelectedIndex(1);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // ✅ FIX
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(
                            const AssetImage('assets/images/list.png'),
                            size: 28,
                            color:
                                _bottomNavigationController.selectedIndex == 1
                                    ? primaryColor
                                    : black,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Bookings",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color:
                                  _bottomNavigationController.selectedIndex ==
                                          1
                                      ? primaryColor
                                      : black,
                              fontWeight:
                                  _bottomNavigationController.selectedIndex ==
                                          1
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 3),
                          _bottomNavigationController.selectedIndex != 1
                              ? const SizedBox()
                              : Container(
                                  height: 2,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(90),
                                    color: primaryColor,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Bounce(
                      scaleFactor: 1.3,
                      onTap: () {
                        _bottomNavigationController.updateSelectedIndex(2);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // ✅ FIX
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(
                            const AssetImage('assets/images/ep_menu.png'),
                            size: 28,
                            color:
                                _bottomNavigationController.selectedIndex == 2
                                    ? primaryColor
                                    : null,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "My Menu",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color:
                                  _bottomNavigationController.selectedIndex ==
                                          2
                                      ? primaryColor
                                      : black,
                              fontWeight:
                                  _bottomNavigationController.selectedIndex ==
                                          2
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 3),
                          _bottomNavigationController.selectedIndex != 2
                              ? const SizedBox()
                              : Container(
                                  height: 2,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(90),
                                    color: primaryColor,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Bounce(
                      scaleFactor: 1.3,
                      onTap: () {
                        _bottomNavigationController.updateSelectedIndex(3);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // ✅ FIX
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(
                            const AssetImage(
                                'assets/images/profile-fill.png'),
                            size: 28,
                            color:
                                _bottomNavigationController.selectedIndex == 3
                                    ? primaryColor
                                    : null,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color:
                                  _bottomNavigationController.selectedIndex ==
                                          3
                                      ? primaryColor
                                      : black,
                              fontWeight:
                                  _bottomNavigationController.selectedIndex ==
                                          3
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 3),
                          _bottomNavigationController.selectedIndex != 3
                              ? const SizedBox()
                              : Container(
                                  height: 2,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(90),
                                    color: primaryColor,
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}



Future<bool?> showExitDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.exit_to_app, color: Color(0xFF63183F)),
            SizedBox(width: 8),
            Text(
              'Exit App',
              style: TextStyle(
                  color: Color(0xFF63183F), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to exit the app?',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Color(0xFF63183F), fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF63183F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Exit',
              style: TextStyle(color: white),
            ),
          ),
        ],
      );
    },
  );
}