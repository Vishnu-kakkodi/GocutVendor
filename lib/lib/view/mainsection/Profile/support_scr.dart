import 'dart:async';
import 'dart:convert';

import 'package:bounce/bounce.dart';
// import 'package:coepd/constants/colors/colors.dart';
// import 'package:coepd/constants/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/constants/constant.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/raise_a_ticker.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  Timer? timmee;

  String requestCall = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get_supportReqs(context, (response) {
      setState(() {
        requestCall = response['contactDetails']['officePhonenumber'];
        support_reqs = response['vendorrequests'];
      });
    });
    timmee = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timmee!.cancel();
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:${requestCall}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Support',
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // Handle onPressed
          },
          icon: Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.black,
            // You can adjust the size and color of the icon here
          ),
        ),
        actions: [
          Align(
            child: InkWell(
              onTap: () {
                _makingPhoneCall();
                // FlutterPhoneDirectCaller.callNumber('8074245829');
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    border: Border.all(color: black.withOpacity(0.2))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Help',
                        style: TextStyle(
                          color: black,
                          fontFamily: "MonM",
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            // Gap(15),
            support_reqs.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: support_reqs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final item = support_reqs[index];
                          return Container(
                            margin: EdgeInsets.only(top: 14),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(-1, 0),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      '#${item["ticketId"]}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Subject:",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: black,
                                    ),
                                  ),
                                  Text(
                                    "${item['reason']}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: black,
                                    ),
                                  ),
                                  Divider(
                                    color: black.withOpacity(0.1),
                                  ),
                                  Text(
                                    "Description:\n${item['description']}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: black.withOpacity(0.2),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                IMAGE_BASE_URL + item['image']),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: black.withOpacity(0.1),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Builder(builder: (context) {
                                    // No need to specify locale
                                    return RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                'Date & Time : ${item['date']}, ${item['time']}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: black,
                                            ),
                                          ),
                                          // TextSpan(
                                          //   text: '     Resolved',
                                          //   style: GoogleFonts.roboto(
                                          //     fontSize: 14,
                                          //     fontWeight:
                                          //         FontWeight.w700,
                                          //     color: Colors.blue,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Reply:\n ${item['reply']}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: black.withOpacity(0.1),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Builder(builder: (context) {
                                    return RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Status : ',
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '${item['status']}'
                                                .toUpperCase(),
                                            style: GoogleFonts.roboto(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: item['status'] == "pending"
                                                  ? Colors.blue
                                                  : black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : Expanded(
                    child: Center(
                    child: Text("No Requests Available"),
                  )),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Bounce(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MakeARequest()));
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
                      "Raise a Ticket",
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
    );
  }
}
