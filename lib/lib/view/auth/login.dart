import 'dart:convert';
import 'dart:io';

import 'package:bounce/bounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocut_vendor/global/data.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/auth/sign-up.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/mainsection.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/auth/otp-verification.dart';
import 'package:gocut_vendor/lib/view/auth/socilaLogin.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:gocut_user/constants/colors.dart';
// import 'package:gocut_user/view/auth/otp-verification.dart';
// import 'package:gocut_user/constants/componets.dart';
// import 'package:gocut_user/view/auth/socilaLogin.dart';
// import 'package:gocut_user/view/controllers/authController.dart';
// import 'package:gocut_user/view/controllers/mainController.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String uuiD = "";
String uEmail = "";

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _check_box = false;
  RegExp _phoneRegExp = RegExp(r'^[0-9]+$');

  TextEditingController _phone = TextEditingController();

  Future googleSigInsss() async {
    SharedPreferences getmaintoken = await SharedPreferences.getInstance();
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/google/login'));
    request.body = json.encode({
      "uuid": "$uuiD",
      "email": "$uEmail",
      "smtype": "Google",
      "fcm_token": "$fcmToken"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

      final responseBody = await response.stream.bytesToString();
  debugPrint("SOCIAL LOGIN RESPONSE BODY: $responseBody");

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      // showToast(
      //   decodedMap['message'],
      //   context: context,
      //   backgroundColor: Colors.red,
      //   animation: StyledToastAnimation.scale,
      //   reverseAnimation: StyledToastAnimation.fade,
      //   position: StyledToastPosition.top,
      //   animDuration: Duration(seconds: 1),
      //   duration: Duration(seconds: 4),
      //   curve: Curves.elasticOut,
      //   reverseCurve: Curves.linear,
      // );

      if (decodedMap['isRegistered'] == false) {
        getmaintoken.setString('mainToken', decodedMap['token']);

        // print(main)
        setState(() {
          accessToken = decodedMap['token']!;
        });
        print("soccccccc${decodedMap['isRegistered']}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Sign_Up(
              mobile: "",
              // emails: uEmail,
              // uuid: uuiD,
            ),
          ),
        );
      } else if (response.statusCode == 405) {
      } else {
        getmaintoken.setString('mainToken', decodedMap['token']);

        // print(main)
        setState(() {
          accessToken = decodedMap['token']!;
        });
        print("soccccccc${accessToken}");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainSection()),
            (route) => false);

        success(mesg: decodedMap['message'], context: context);
      }

       Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MainSection();
        },
      ));
      print(await response.stream.bytesToString());
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
      // showToast(
      //   decodedMap['message'],
      //   context: context,
      //   backgroundColor: Colors.red,
      //   animation: StyledToastAnimation.scale,
      //   reverseAnimation: StyledToastAnimation.fade,
      //   position: StyledToastPosition.top,
      //   animDuration: Duration(seconds: 1),
      //   duration: Duration(seconds: 4),
      //   curve: Curves.elasticOut,
      //   reverseCurve: Curves.linear,
      // );
      // print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Container(
                  height: 166,
                  width: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"))),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextMedium(
                text: "Welcome Back",
                fontSize: 30,
              ),
              SizedBox(
                height: 14,
              ),
              TextRegular(
                text: "Sign in to Continue",
                textColor: black.withOpacity(0.7),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: _phone.text.length > 0
                            ? Colors.red
                            : black.withOpacity(0.5)),
                  ),
                ),
                child: TextField(
                  controller: _phone,
                  onChanged: (val) {
                    setState(() {});
                  },
                  style:
                      TextStyle(color: black, fontFamily: 'IntM', fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, right: 0, bottom: 0),
                    hintText: "Contact Number",
                    hintStyle: TextStyle(
                        color: black.withOpacity(0.8),
                        fontFamily: 'IntR',
                        fontSize: 13),
                    icon: Image.asset(
                      "assets/images/login.png", // Replace with the path to your image
                      height: 25,
                      width: 25,
                      color: black,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextRegular(
                text:
                    "Your number is safe with us, we don’t use your number for any unsolicited communication.",
                fontSize: 11,
              ),
              SizedBox(
                height: 64,
              ),
              Center(
                child: CustomContainer(
                  onPressed: () {
                    if (_phone.text.length < 10) {
                      failed(
                          mesg: "Please enter correct mobile number",
                          context: context);
                    } else {
                      sendOTp(context, _phone.text, fcmToken, (response) {
                        setState(() {
                          sendOTPMap = response['data'];
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Otp_Verification(
                              mobile: _phone.text,
                            ),
                          ),
                        );
                      });
                      // Provider.of<AuthController>(context, listen: false)
                      //     .loginUser(context: context, phone: _phone.text);
                    }
                  },
                  textName: "Next",
                  height: 42,
                  // width: 201,
                ),
              ),
              SizedBox(
                height: 23,
              ),
              !Platform.isAndroid
                  ? SizedBox()
                  : Center(
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          final GoogleSignIn googleSignIn = GoogleSignIn();
                          await googleSignIn.signOut();
                          GoogleSignInAccount? user = await Authentication.signInWithGoogle(
                              context);

                          setState(() {
                            uuiD = user!.id;
                            uEmail = user.email!;
                          });

                          googleSigInsss();
                        },
                      ),
                    ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Bounce(
              //       scaleFactor: 0.87,
              //       onTap: () async {
              // final GoogleSignIn googleSignIn = GoogleSignIn();
              // await googleSignIn.signOut();
              // User? user = await Authentication.signInWithGoogle(
              //     context: context);
              //       },
              //       child: Container(
              //         height: 30,
              //         width: 30,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           // color: black,
              //           image: DecorationImage(
              //             fit: BoxFit.fill,
              //             image: AssetImage(
              //               "assets/images/Google.png",
              //             ),
              //           ),
              //         ),
              //       ),
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
