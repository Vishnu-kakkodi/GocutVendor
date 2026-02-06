import 'dart:convert';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/global/data.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

Map notiMap = {};

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    getNoti();
  }

  Future getNoti() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request('POST',
        Uri.parse('$BASE_URL/vendor/notification/getallnotificationsbyuserid'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        notiMap = decodedMap;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future deleteNoti(iddd) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'DELETE', Uri.parse('$BASE_URL/vendor/notification/deletenotif'));
    request.bodyFields = {'_id': '$iddd'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      getNoti();
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
    }
  }

  Future deleteNotiAll() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'DELETE', Uri.parse('$BASE_URL/vendor/notification/deletallenotif'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      getNoti();
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
    }
  }

  int val = 0;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Future.delayed(Duration(seconds: 2), () {
  //     setState(() {
  //       val = 1;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgr/
        elevation: 0,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            print(fcmToken);
          },
          child: Text(
            "Notification",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // Handle onPressed
          },
          icon: Icon(
            Icons.arrow_back,
            size: 24,
            color: black,
            // You can adjust the size and color of the icon here
          ),
        ),
        actions: [
          Bounce(
            onTap: () {
              deleteNotiAll();
            },
            child: Animate(
              autoPlay: true,
              effects: [ShimmerEffect(), FadeEffect()],
              child: Align(
                child: AnimatedContainer(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.red),
                    duration: Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13.0, vertical: 5),
                      child: Text(
                        "Clear All",
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                      ),
                    )),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Animate(
                delay: Duration(milliseconds: 600),
                effects: [ShimmerEffect(), FadeEffect()],
                child: notiMap.isEmpty
                    ? ShimmerList()
                    : notiMap['notifResult'].isEmpty
                        ? Center(child: Text("No Notifications available"))
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: notiMap['notifResult'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: BehindMotion(),
                                  children: [
                                    SlidableAction(
                                      spacing: 9,
                                      flex: 4,
                                      borderRadius: BorderRadius.circular(20),
                                      onPressed: (val) {
                                        // print(item['_id']);
                                        EasyLoading.show();
                                        deleteNoti(notiMap['notifResult'][index]
                                            ['_id']);
                                        // showModalBottomSheet(
                                        //   isScrollControlled: true,
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.only(
                                        //       topLeft:
                                        //           Radius.circular(40),
                                        //       topRight:
                                        //           Radius.circular(40),
                                        //     ),
                                        //   ),
                                        //   context: context,
                                        //   builder:
                                        //       (BuildContext context) {
                                        //     return Padding(
                                        //       padding:
                                        //           MediaQuery.of(context)
                                        //               .viewInsets,
                                        //       child: CancellReason(
                                        //           ifff: orderHisMap[
                                        //                   'bookings']
                                        //               [index]['_id']),
                                        //     );
                                        //   },
                                        // );
                                      },
                                      backgroundColor: Colors.red,
                                      label: "Delete",
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: black.withOpacity(0.1),
                                            width: 1)),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 5),
                                              Text(
                                                notiMap['notifResult'][index]
                                                    ['title'],
                                                style: GoogleFonts.poppins(
                                                  color: black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                notiMap['notifResult'][index]
                                                    ['description'],
                                                style: GoogleFonts.poppins(
                                                  color: black.withOpacity(0.3),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              color: white,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  IMAGE_BASE_URL +
                                                      notiMap['notifResult']
                                                          [index]['image'],
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        SizedBox(width: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
