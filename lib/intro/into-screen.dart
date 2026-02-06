import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/view/auth/login-signup.dart';
import 'package:gocut_vendor/lib/view/auth/login.dart';
// import 'package:gocut_user/constants/colors.dart';

// import 'package:gocut_user/view/auth/login-signup.dart';
// import 'package:gocut_user/constants/componets.dart';
// import 'package:gocut_user/view/controllers/mainController.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Intro_Screen extends StatefulWidget {
  const Intro_Screen({super.key});

  @override
  State<Intro_Screen> createState() => _Intro_ScreenState();
}

class _Intro_ScreenState extends State<Intro_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // latitude_and_longitude();
  }

  // Future latitude_and_longitude() async {
  //   print("splashcurrentlat: fkdufhdu");
  //   final permissionStatus = await Permission.location.request();
  //   if (permissionStatus.isGranted) {
  //     // Request the current position
  //     Position? position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best,
  //     );

  //     double latitude_user = position.latitude;
  //     double longitude_user = position.longitude;
  //     Provider.of<MainController>(context, listen: false)
  //         .toggleUserLongitudeAndLatitudeValue(
  //             latitude_user.toString(), longitude_user.toString());
  //     print("splashcurrentlat: ${latitude_user}, ${longitude_user}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              height: 179,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"))),
            ),
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Elegant sitting room where guests are received. type of: front room, living room, living-room, parlor, parlour",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Bounce(
                  scaleFactor: 0.87,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext) {
                      // return LogIn_SignUp();
                      return LogIn();
                    }));
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: red),
                    child: Icon(
                      Icons.arrow_forward,
                      color: white,
                    ),
                  ),
                )),
            // Row(
            //   children: [
            //     InkWell(
            //       onTap: () {

            //       },
            //       child: Container(
            //         height: 48,
            //         width: 48,
            //         decoration: BoxDecoration(
            //             color: primaryColor, shape: BoxShape.circle),
            //         child: Icon(
            //           Icons.arrow_forward,
            //           color: white,
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton:
    );
  }
}
