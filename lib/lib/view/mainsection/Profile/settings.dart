import 'dart:async';
import 'dart:convert';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/view/auth/login-signup.dart';
import 'package:gocut_vendor/lib/view/auth/login.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/edit_slots.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/color/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/policies/policy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool orderSw = false;
  bool smsSw = false;

  Timer? timee;

  @override
  void initState() {
    super.initState();
    timee = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timee!.cancel();
  }

  Future updateStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request('PUT',
        Uri.parse('$BASE_URL/vendor/notification/updatenotificationbell'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print(
          decodedMap); // success(mesg: decodedMap['message'], context: context);
      getNotiStatus();
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getNotiStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request('POST',
        Uri.parse('$BASE_URL/vendor/notification/getnotificationstatus'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        getNotiSta = decodedMap['vendor']['notification_bell'];
      });
      //
    } else {
      print(response.reasonPhrase);
    }
  }



Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    updateStatus();
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Notification",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              ),
                              Text(
                                "Notification alert for order confirmation",
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ),
                        Switch(
                            activeColor: primaryColor,
                            activeTrackColor: secondaryColor,
                            value: getNotiSta,
                            onChanged: (val) {
                              updateStatus();
                              setState(() {
                                // orderSw = val;
                              });
                            })
                      ],
                    ),
                  ),
                ),
              ),
              // Divider(),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "OTP Confirmation",
              //                 style: GoogleFonts.poppins(
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w600,
              //                     color: black),
              //               ),
              //               Text(
              //                 "Confirmation OTP fro service",
              //                 style: GoogleFonts.poppins(
              //                     fontSize: 11,
              //                     fontWeight: FontWeight.w300,
              //                     color: Colors.red),
              //               )
              //             ],
              //           ),
              //         ),
              //         Switch(
              //             activeColor: primaryColor,
              //             activeTrackColor: secondaryColor,
              //             value: smsSw,
              //             onChanged: (val) {
              //               setState(() {
              //                 smsSw = val;
              //               });
              //             })
              //       ],
              //     ),
              //   ),
              // ),
              Divider(),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Bounce(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => EditSlots(),
              //             ),
              //           );
              //         },
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Row(
              //                     children: [
              //                       Container(
              //                         width: 30,
              //                         height: 30,
              //                         decoration: BoxDecoration(
              //                           color: Colors.green.withOpacity(0.9),
              //                           shape: BoxShape.circle,
              //                         ),
              //                         child: Icon(
              //                           Icons.edit,
              //                           size: 20,
              //                           color: Colors.white,
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         width: 10,
              //                       ),
              //                       Text(
              //                         "Edit Slots",
              //                         style: GoogleFonts.poppins(
              //                             fontSize: 14,
              //                             fontWeight: FontWeight.w600,
              //                             color: black),
              //                       ),
              //                     ],
              //                   ),
              //                   // Text(
              //                   //   "Confirmation OTP fro service",
              //                   //   style: GoogleFonts.poppins(
              //                   //       fontSize: 11,
              //                   //       fontWeight: FontWeight.w300,
              //                   //       color: Colors.red),
              //                   // )
              //                 ],
              //               ),
              //             ),
              //             Icon(Icons.arrow_right),
              //             // Switch(
              //             //     activeColor: primaryColor,
              //             //     activeTrackColor: secondaryColor,
              //             //     value: smsSw,
              //             //     onChanged: (val) {
              //             //       setState(() {
              //             //         smsSw = val;
              //             //       });
              //             //     })
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Bounce(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DeleteAccDialog();
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Delete Account",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: black),
                                    ),
                                  ],
                                ),
                                // Text(
                                //   "Confirmation OTP fro service",
                                //   style: GoogleFonts.poppins(
                                //       fontSize: 11,
                                //       fontWeight: FontWeight.w300,
                                //       color: Colors.red),
                                // )
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_right),
                          // Switch(
                          //     activeColor: primaryColor,
                          //     activeTrackColor: secondaryColor,
                          //     value: smsSw,
                          //     onChanged: (val) {
                          //       setState(() {
                          //         smsSw = val;
                          //       });
                          //     })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
         ListTile(
  onTap: () {
    _launchUrl("https://go-cut-vendor-policies.onrender.com/cancel-refund");
  },
  title: const Text("Refund Policy"),
  trailing: const Icon(Icons.arrow_right),
),
const Divider(),

ListTile(
  onTap: () {
    _launchUrl("https://go-cut-vendor-policies.onrender.com/privacy-and-policy");
  },
  title: const Text("Privacy Policy"),
  trailing: const Icon(Icons.arrow_right),
),
const Divider(),

ListTile(
  onTap: () {
    _launchUrl("https://go-cut-vendor-policies.onrender.com/terms-and-conditions");
  },
  title: const Text("Terms & Conditions"),
  trailing: const Icon(Icons.arrow_right),
),

              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::://
//::::::::::::::::::::::::DeleteAcc Section::::::::::::::::::::::::::::::::::::::::://
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::://

class DeleteAccDialog extends StatefulWidget {
  @override
  State<DeleteAccDialog> createState() => _DeleteAccDialogState();
}

class _DeleteAccDialogState extends State<DeleteAccDialog> {
  Future deactivateAccount() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/auth/deletevendoraccount'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);

      data.clear();
      setState(() {
        accessToken = '';
      });
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => LogIn()), (route) => false);
      // LogIn_SignUp()),
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBoxLsss(context),
    ).animate().fadeIn().shimmer();
  }

  Widget contentBoxLsss(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/del.png', // Replace with your own image asset path
                height: 170,
                width: 170,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Are you sure you want to\delete your account?',
                  style: GoogleFonts.inter(
                    color: black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              //  SizedBox(
              //         height: 43,
              //       ),
              Bounce(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //     context, FadeRouteBuilder(page: MainSection()));
                },
                child: AnimatedContainer(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: sharp_red_gradeint,
                    ),
                    duration: Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Naah, Just Kidding",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 14),
              Bounce(
                onTap: () async {
                  // SharedPreferences data =
                  //     await SharedPreferences.getInstance();
                  // data.clear();
                  deactivateAccount();
                  // setState(() {
                  //   amountDis = "";
                  //   totalAmot = "";
                  //   selectedAdd = "";
                  // });

                  // Navigator.pushAndRemoveUntil(context,
                  //     FadeRouteBuilder(page: LoginScreen()), (route) => false);
                },
                child: AnimatedContainer(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: sharp_red_gradeint,
                    ),
                    duration: Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Align(
                        child: AnimatedContainer(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white
                              // gradient: sharp_green_gradeint,
                              ),
                          duration: Duration(milliseconds: 200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Yes, Delete my account!",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
