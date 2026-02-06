import 'dart:async';
import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/auth/sign-up.dart';
import 'package:gocut_vendor/lib/view/mainsection/mainsection.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:lottie/lottie.dart';
// import 'package:gocut_user/constants/colors.dart';
// import 'package:gocut_user/view/auth/sign-up.dart';
// import 'package:gocut_user/constants/componets.dart';
// import 'package:gocut_user/view/controllers/authController.dart';
// import 'package:gocut_user/view/controllers/mainController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp_Verification extends StatefulWidget {
  Otp_Verification({super.key, required this.mobile});
  String mobile;

  @override
  State<Otp_Verification> createState() => _Otp_VerificationState();
}

class _Otp_VerificationState extends State<Otp_Verification> {
  TextEditingController _otp1C = TextEditingController();
  TextEditingController _otp2C = TextEditingController();
  TextEditingController _otp3C = TextEditingController();
  TextEditingController _otp4C = TextEditingController();
  TextEditingController _otp5C = TextEditingController();
  TextEditingController _otp6C = TextEditingController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   Future.delayed(Duration.zero, () {
  //     Provider.of<AuthController>(context, listen: false).startTimer();
  //   });
  // }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
    sendOTp(context, widget.mobile, "", (response) {
      setState(() {
        sendOTPMap = response['data'];
      });
    });
  }

  bool focVal = true;

  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
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

      success(mesg: decodedMap['message'], context: context);

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
                text: "OTP Verification",
                fontSize: 30,
              ),
              SizedBox(
                height: 14,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "Enter Four digits verification code that you received on your number ",
                      style: TextStyle(
                        fontFamily: "IntR",
                        color: black.withOpacity(0.6),
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                      ),
                    ),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (BuildContext) {
                          //   return Terms_Condition();
                          // }));
                        },
                        child: Text(
                          widget.mobile,
                          style: TextStyle(
                            fontFamily: "IntM",
                            color: red,
                            decoration: TextDecoration.underline,
                            decorationColor: red,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildOtpTextField(_otp1C, _otp2C),

                  buildOtpTextField(_otp2C, _otp3C),

                  buildOtpTextField(_otp3C, _otp4C),

                  buildOtpTextField(_otp4C, _otp5C),

                  // buildOtpTextField(
                  //     _otp5C, _otp6C), // Pass null for the last box

                  // buildOtpTextField(
                  //     _otp6C, _otp6C), // Pass null for the last box
                ],
              ),
              SizedBox(
                height: 24,
              ),
              focVal == false
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Row(
                        children: [
                          Text(
                            secondsRemaining.toString().length < 2
                                ? "00:0$secondsRemaining"
                                : "00:$secondsRemaining",
                            style: TextStyle(
                                fontFamily: "PopR",
                                fontSize: 14,
                                decoration: enableResend
                                    ? TextDecoration.none
                                    : TextDecoration.underline,
                                color: enableResend
                                    ? Colors.red.shade100
                                    : Colors.red.withOpacity(0.7)),
                          ),
                          Spacer(),
                          enableResend == false
                              ? SizedBox()
                              : InkWell(
                                  onTap: enableResend ? _resendCode : null,
                                  child: Text(
                                    "Resend OTP",
                                    style: TextStyle(
                                        fontFamily: "PopR",
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                        color: black.withOpacity(0.3)),
                                  ),
                                ),
                        ],
                      ),
                    ),

              // Consumer<AuthController>(
              //   builder: (context, authControllerData, child) {
              //     return Row(
              //       children: [
              //         RichText(
              //           text: TextSpan(
              //             children: [
              //               WidgetSpan(
              //                 child: InkWell(
              //                   onTap: () {
              //                     // Navigator.push(context,
              //                     //     MaterialPageRoute(builder: (BuildContext) {
              //                     //   return Terms_Condition();
              //                     // }));
              //                   },
              //                   child: Text(
              //                     authControllerData.remainingTime > 0
              //                         ? '00:${authControllerData.remainingTime.toString().padLeft(2, '0')}'
              //                         : '00:00',
              //                     style: TextStyle(
              //                       fontFamily: "IntM",
              //                       color: red.withOpacity(0.5),
              //                       decoration: TextDecoration.underline,
              //                       decorationColor: red,
              //                       overflow: TextOverflow.ellipsis,
              //                       fontSize: 12,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Spacer(),
              //         RichText(
              //           text: TextSpan(
              //             children: [
              //               WidgetSpan(
              //                 child: InkWell(
              //                   onTap: () {
              //                     // Navigator.push(context,
              //                     //     MaterialPageRoute(builder: (BuildContext) {
              //                     //   return Terms_Condition();
              //                     // }));

              //                     authControllerData.loginUser(
              //                         phone: widget.mobile, context: context);
              //                     authControllerData.startTimer();
              //                   },
              //                   child: Text(
              //                     "Resend OTP",
              //                     style: TextStyle(
              //                       fontFamily: "IntR",
              //                       color: authControllerData.remainingTime > 0
              //                           ? black.withOpacity(0.3)
              //                           : black,
              //                       decoration: TextDecoration.underline,
              //                       decorationColor: black,
              //                       overflow: TextOverflow.ellipsis,
              //                       fontSize: 12,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: CustomContainer(
                  onPressed: () async {
                    SharedPreferences getDaa =
                        await SharedPreferences.getInstance();
                    if (_otp1C.text.length < 1 ||
                        _otp2C.text.length < 1 ||
                        _otp3C.text.length < 1 ||
                        _otp4C.text.length < 1) {
                      failed(mesg: "Please enter otp", context: context);
                    } else {
                      String ottp =
                          "${_otp1C.text + _otp2C.text + _otp3C.text + _otp4C.text}";
                      verifydOTp(context, widget.mobile, ottp, (response) {
                        print(response['token']);
                        setState(() {
                          accessToken = response['token'];
                          // sendOTPMap = response['data'];
                          print(accessToken);
                        });

                        getDaa.setString('mainToken', accessToken);

                        print('the verification : ${response} ------------>');

                        getStatus();
                      });
                      // Provider.of<AuthController>(context, listen: false)
                      //     .validateOTP(
                      //         widget.mobile,
                      //         _otp1C.text +
                      //             _otp2C.text +
                      //             _otp3C.text +
                      //             _otp4C.text,
                      //         context);
                    }
                  },
                  textName: "verify",
                  height: 42,
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpTextField(TextEditingController currentController,
      TextEditingController? nextController) {
    return Container(
      height: 47,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: currentController.text != "" ? secondaryColor : silver_grey,
      ),
      child: Center(
        child: TextFormField(
          controller: currentController,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "IntS", fontSize: 18, color: black),
          onChanged: (value) {
            if (value.isEmpty) {
              // If the current box is empty, move focus to the previous box
              if (currentController.text.isEmpty && nextController != null) {
                FocusScope.of(context).previousFocus();
              }
            } else if (value.length == 1 && nextController != null) {
              // If a digit is entered, move focus to the next box
              FocusScope.of(context).nextFocus();
            }
            // setState(() {}); // You may not need to call setState here
          },
          cursorHeight: 20,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 20),
            hintText: "",
            hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontFamily: "PopR",
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: currentController.text.isNotEmpty
                    ? silver_grey
                    : silver_grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: currentController.text.isNotEmpty
                    ? silver_grey
                    : silver_grey,
              ),
            ),
          ),
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Align(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 320,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: white,
            ),
            child: BlurryContainer(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Lottie.asset(
                      'assets/animations/info_dia.json',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Important Info",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: black,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'Your account is still under verification process and it is going to take some time. We will let you know when the verification process completed.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Bounce(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          gradient: sharp_green_gradeint,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(1, 1),
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: black.withOpacity(0.4)),
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 0,
                                spreadRadius: 0,
                                color: black.withOpacity(0.1))
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ok! Sure.",
                            style: TextStyle(
                              color: white,
                              fontFamily: 'PopS',
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              blur: 5,
              width: 200,
              height: 200,
              elevation: 0,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
          ),
        ),
      ),
    );
  }
}
