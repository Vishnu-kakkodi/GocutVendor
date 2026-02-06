import 'dart:convert';

import 'package:bounce/bounce.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class StartService extends StatefulWidget {
  const StartService({super.key});

  @override
  State<StartService> createState() => _StartServiceState();
}

class _StartServiceState extends State<StartService> {
  @override
  void initState() {
    super.initState();
    // print(slotDetailsMap['data'][0]['_id']);
  }

  Future getTodaysBooking() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/gettodaybookings'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        todaysBookingMap = decodedMap;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future startServ(bookingID) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/startservice'));
    request.bodyFields = {'bookingId': bookingID, 'otp': '$code'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      await getTodaysBooking();
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return EndService(
              iddd: bookingID,
            ).animate().scale().shimmer();
          });
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
      print(response.reasonPhrase);
    }
  }

  String code = '';

  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const length = 4;
    Color borderColor = primaryColor;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: GoogleFonts.poppins(fontSize: 22, color: Colors.white),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
          gradient: sharp_green_gradeint),
      // decoration: BoxDecoration(
      //   color: fillColor,
      //   // gradient: sharp_green_gradeint,
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: Colors.transparent),
      // ),
    );
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: black.withOpacity(0.2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: white,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/startser.png',
                      height: 200,
                    ),
                  ),
                  Center(
                    child: Text(
                      slotDetailsMap['data'][0]['user']['name'].toString(),
                      // "Narshima Varma",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      "${slotDetailsMap['data'][0]['time']}, Chair ${slotDetailsMap['data'][0]['chairNumber']}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ListView.separated(
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //         child: Row(
                  //           children: [
                  //             Expanded(
                  //               child: Text(
                  //                 slotDetailsMap['data'][0]['vendorservices']
                  //                         ['name'] ??
                  //                     "",
                  //                 style: GoogleFonts.poppins(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w500,
                  //                   color: black,
                  //                 ),
                  //               ),
                  //             ),
                  //             Text(
                  //               "₹ ${slotDetailsMap['data'][0]['vendorservices']['offerPrice']}",
                  //               style: GoogleFonts.poppins(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: black,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //     itemCount: 2,
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     separatorBuilder: (BuildContext context, int index) {
                  //       return Divider();
                  //     },
                  //   ),
                  // ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Verify to start service",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: black,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        height: 68,
                        child: Pinput(
                          // androidSmsAutofillMethod:
                          //     // AndroidSmsAutofillMethod.smsRetrieverApi,
                          length: length,
                          controller: controller,
                          focusNode: focusNode,
                          defaultPinTheme: defaultPinTheme,
                          onCompleted: (pin) {
                            setState(() {
                              code = pin;
                              print(code);
                            });
                            print(code);
                            // setState(() => showError = pin != '555555');
                            // print(controller.text);
                            // EasyLoading.dismiss();
                            // EasyLoading.show(status: "Verifying OTP");
                            // otpVerification(context, controller.text);
                          },
                          focusedPinTheme: defaultPinTheme.copyWith(
                            height: 59,
                            width: 59,
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(color: borderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyWith(
                            decoration: BoxDecoration(
                              color: errorColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Bounce(
                      onTap: () async {
                        if (code == "" || code.length < 4) {
                          failed(
                              mesg: "Please enter service OTP first",
                              context: context);
                        } else {
                          EasyLoading.show();
                          await startServ(slotDetailsMap['data'][0]['_id']);
                        }

                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => MakeARequest()));
                        // Navigator.of(context).push(
                        //   FadeRouteBuilder(
                        //     page: const MakeARequest(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // color: primaryColor,
                          gradient: sharp_green_gradeint,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(-1, 0),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Start Service",
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//==========================================================================//
//=============================END SERVICE==================================//
//==========================================================================//

class EndService extends StatefulWidget {
  String iddd;
  EndService({super.key, required this.iddd});

  @override
  State<EndService> createState() => _EndServiceState();
}

class _EndServiceState extends State<EndService> {
  Future getTodaysBooking() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/gettodaybookings'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        todaysBookingMap = decodedMap;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future endService() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request =
        http.Request('PUT', Uri.parse('$BASE_URL/vendor/service/endservice'));
    request.bodyFields = {'bookingId': widget.iddd};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      await getTodaysBooking();
      Navigator.pop(context);
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black.withOpacity(0.2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: white,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/ednser.png',
                      height: 200,
                    ),
                  ),
                  Center(
                    child: Text(
                      "",
                      // slotDetailsMap['data'][0]['user']['name'].toString(),
                      // "Narshima Varma",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      "",
                      // "${slotDetailsMap['data'][0]['time']}, Chair ${slotDetailsMap['data'][0]['chairNumber']}",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ListView.separated(
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //         child: Row(
                  //           children: [
                  //             Expanded(
                  //               child: Text(
                  //                 slotDetailsMap['data'][0]['vendorservices']
                  //                     ['name'],
                  //                 style: GoogleFonts.poppins(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w500,
                  //                   color: black,
                  //                 ),
                  //               ),
                  //             ),
                  //             Text(
                  //               "₹ ${slotDetailsMap['data'][0]['vendorservices']['offerPrice']}",
                  //               style: GoogleFonts.poppins(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: black,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //     itemCount: 2,
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     separatorBuilder: (BuildContext context, int index) {
                  //       return Divider();
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 2),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Bounce(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Booking'),
                              content: Text(
                                  'Are you sure you want to complete the booking?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // User canceled the booking
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    EasyLoading.show();
                                    Navigator.of(context).pop(true);
                                    // User confirmed the booking
                                    endService();

                                    // Perform booking logic here
                                  },
                                  child: Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );

                        // Navigator.pop(context);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => MakeARequest()));
                        // Navigator.of(context).push(
                        //   FadeRouteBuilder(
                        //     page: const MakeARequest(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // color: primaryColor,
                          gradient: sharp_green_gradeint,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(-1, 0),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "End Service",
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
