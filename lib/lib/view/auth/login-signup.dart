import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/view/auth/login.dart';
// import 'package:gocut_user/constants/colors.dart';

// import 'package:gocut_user/view/auth/login-signup.dart';
// import 'package:gocut_user/constants/componets.dart';
// import 'package:gocut_user/view/auth/login.dart';
// import 'package:gocut_user/view/controllers/mainController.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LogIn_SignUp extends StatefulWidget {
  const LogIn_SignUp({super.key});

  @override
  State<LogIn_SignUp> createState() => _LogIn_SignUpState();
}

class _LogIn_SignUpState extends State<LogIn_SignUp> {
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
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                height: 249,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"))),
              ),
              SizedBox(
                height: 66,
              ),
              CustomContainer(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext) {
                    return LogIn();
                  }));
                },
                textName: "Login / Sign Up",
              ),
              // SizedBox(
              //   height: 38,
              // ),
              // CustomContainer(
              //   onPressed: () {},
              //   textName: "Continue As Guest",
              //   buttonColor: secondaryColor,
              // ),
              SizedBox(
                height: 45,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: 96,
              //       height: 1,
              //       color: black.withOpacity(0.4),
              //     ),
              //     SizedBox(
              //       width: 7,
              //     ),
              //     TextMedium(text: "or"),
              //     SizedBox(
              //       width: 7,
              //     ),
              //     Container(
              //       width: 96,
              //       height: 1,
              //       color: black.withOpacity(0.4),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 50,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: 40,
              //       width: 40,
              //       decoration: BoxDecoration(
              //           image: DecorationImage(
              //               image: AssetImage("assets/images/Google.png"))),
              //     ),
              //     SizedBox(
              //       width: 30,
              //     ),
              //     Container(
              //       height: 40,
              //       width: 40,
              //       decoration: BoxDecoration(
              //           image: DecorationImage(
              //               image: AssetImage("assets/images/face.png"))),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
