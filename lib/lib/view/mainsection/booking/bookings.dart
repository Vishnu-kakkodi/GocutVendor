import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:bounce/bounce.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/controllers/bottomNavigation_controller.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/gallery.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/orderhistory.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/home.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/start_servic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int val = 0;
  Timer? stettts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        val = 1;
      });
    });
    getTodaysBooking();
    stettts = Timer.periodic(Duration(seconds: 1), (cal) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    stettts!.cancel();
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

      // print("today bookings all${decodedMap['todayBookings'][0]['chairId']}");
      print("today bookings all${decodedMap}");
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
      // print(response.reasonPhrase);
    }
  }

  String _formatDate(DateTime date) {
    String daySuffix = _getDaySuffix(date.day);
    String formattedDate = DateFormat('d').format(date) +
        daySuffix +
        ' ' +
        DateFormat('MMMM, yyyy').format(date);
    return formattedDate;
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Future getUserDetailforVen(chairID, timeID, orderId) async {
    print("pirnt stat time data ${chairID + "   " + timeID}");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/details/getdetailsforvendor'));
    request.bodyFields = {
      'chairId': '$chairID',
      'timeid': '$timeID',
      'orderId': '$orderId'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        slotDetailsMap = decodedMap;
      });

      print("pirnt stat time data ${slotDetailsMap}");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StartService();
          });
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      EasyLoading.dismiss();
      failed(mesg: decodedMap['message'], context: context);
      print(response.reasonPhrase);
    }
  }

  final _bottomNavigationController = Get.find<BottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _bottomNavigationController.updateSelectedIndex(0);
        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: InkWell(
            onTap: () {
              print(todaysBookingMap);
            },
            child: Text(
              "Today's Booking",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
        body: Container(
          color: white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: todaysBookingMap.isEmpty
                ? ShimmerList()
                : todaysBookingMap['todayBookings'].isEmpty
                    ? Center(
                        child: Text("No booking were made"),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "*Swipe left to cancel the booking...",
                            style: GoogleFonts.poppins(
                              color: Colors.red.withOpacity(0.3),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Slidable(
                                    endActionPane: todaysBookingMap[
                                                    'todayBookings'][index]
                                                ['status'] !=
                                            'pending'
                                        ? null
                                        : ActionPane(
                                            motion: BehindMotion(),
                                            children: [
                                              SlidableAction(
                                                flex: 4,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onPressed: (val) {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(40),
                                                        topRight:
                                                            Radius.circular(40),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Padding(
                                                        padding: MediaQuery.of(
                                                                context)
                                                            .viewInsets,
                                                        child: CancellReason(
                                                            ifff: todaysBookingMap[
                                                                    'todayBookings']
                                                                [index]['_id']),
                                                      );
                                                    },
                                                  );
                                                },
                                                backgroundColor: Colors.red,
                                                label: "Cancel",
                                              ),
                                            ],
                                          ),
                                    child: Bounce(
                                      onTap: () async {
                                        print(
                                            "get print all bookings${todaysBookingMap['todayBookings'][index]['userName']}");
                                        if (todaysBookingMap['todayBookings']
                                                [index]['status'] ==
                                            'pending') {
                                          getUserDetailforVen(
                                            todaysBookingMap['todayBookings']
                                                [index]['chairId'],
                                            todaysBookingMap['todayBookings']
                                                [index]['timeid'],
                                            todaysBookingMap['todayBookings']
                                                [index]['orderId'],
                                          );
                                        } else if (todaysBookingMap[
                                                    'todayBookings'][index]
                                                ['status'] ==
                                            'started') {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return EndService(
                                                  iddd: todaysBookingMap[
                                                          'todayBookings']
                                                      [index]['_id'],
                                                ).animate().scale().shimmer();
                                              });
                                        } else if (todaysBookingMap[
                                                    'todayBookings'][index]
                                                ['status'] ==
                                            'cancelled') {
                                          Flushbar(
                                              margin: EdgeInsets.all(6.0),
                                              flushbarStyle:
                                                  FlushbarStyle.FLOATING,
                                              textDirection:
                                                  Directionality.of(context),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              flushbarPosition:
                                                  FlushbarPosition.TOP,
                                              title:
                                                  "Hey ${vendor_data['name']}",
                                              message:
                                                  "This booking was cancelled!",
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3))
                                            ..show(context);
                                        } else {
                                          Flushbar(
                                              margin: EdgeInsets.all(6.0),
                                              flushbarStyle:
                                                  FlushbarStyle.FLOATING,
                                              textDirection:
                                                  Directionality.of(context),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              flushbarPosition:
                                                  FlushbarPosition.TOP,
                                              title:
                                                  "Hey ${vendor_data['name']}",
                                              message:
                                                  "This booking was completed.",
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 3))
                                            ..show(context);
                                        }
                                        // showDialog(
                                        //     barrierDismissible: false,
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return StartService();
                                        //     });
                                      },
                                      child: Container(
                                        // height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: black.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 12.0),
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        todaysBookingMap['todayBookings']
                                                                        [index][
                                                                    'userImage'] ==
                                                                ""
                                                            ? 'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg'
                                                            : IMAGE_BASE_URL +
                                                                todaysBookingMap[
                                                                            'todayBookings']
                                                                        [index][
                                                                    'userImage'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                todaysBookingMap['todayBookings']
                                                                    [index][
                                                                'referenceImage'] ==
                                                            "" ||
                                                        todaysBookingMap[
                                                                        'todayBookings']
                                                                    [index][
                                                                'referenceImage'] ==
                                                            null
                                                    ? SizedBox()
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            top: 12.0),
                                                        height: 70,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              todaysBookingMap['todayBookings']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'referenceImage'] ==
                                                                      ""
                                                                  ? 'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg'
                                                                  : IMAGE_BASE_URL +
                                                                      todaysBookingMap['todayBookings']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'referenceImage'],
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      TextSemiBold(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    text:
                                                                        "Reference\nImage",
                                                                    fontSize: 9,
                                                                    textColor: black
                                                                        .withOpacity(
                                                                            0.4),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              90),
                                                                  onTap: () {
                                                                    showModalBottomSheet<
                                                                        void>(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      isScrollControlled:
                                                                          true,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              30),
                                                                        ),
                                                                      ),
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Padding(
                                                                          padding:
                                                                              MediaQuery.of(context).viewInsets,
                                                                          child: getData(
                                                                              IMAGE_BASE_URL + todaysBookingMap['todayBookings'][index]['referenceImage'],
                                                                              context),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 25,
                                                                    width: 25,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              white,
                                                                          width:
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              90),
                                                                      color: black
                                                                          .withOpacity(
                                                                              0.2),
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .open_in_full,
                                                                      color:
                                                                          white,
                                                                      size: 16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          todaysBookingMap[
                                                                          'todayBookings']
                                                                      [index][
                                                                  'userName'] ??
                                                              "",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: black,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: todaysBookingMap['todayBookings']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'status'] ==
                                                                    "pending"
                                                                ? Colors.white
                                                                : todaysBookingMap['todayBookings'][index]
                                                                            [
                                                                            'status'] ==
                                                                        "cancelled"
                                                                    ? Colors
                                                                        .white
                                                                    : todaysBookingMap['todayBookings'][index]['status'] ==
                                                                            "completed"
                                                                        ? primaryColor
                                                                        : white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        90),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .25),
                                                                offset: Offset(
                                                                    1, 1),
                                                                blurRadius: 1,
                                                                spreadRadius: 1,
                                                              ),
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .0),
                                                                offset: Offset(
                                                                    1, 1),
                                                                blurRadius: 1,
                                                                spreadRadius: 1,
                                                              )
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        4.0,
                                                                    vertical:
                                                                        3.0),
                                                            child: Center(
                                                              child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Container(
                                                                      height: 8,
                                                                      width: 8,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(90),
                                                                          color: todaysBookingMap['todayBookings'][index]['status'] == "pending"
                                                                              ? Colors.grey
                                                                              : todaysBookingMap['todayBookings'][index]['status'] == "cancelled"
                                                                                  ? Colors.red
                                                                                  : todaysBookingMap['todayBookings'][index]['status'] == "completed"
                                                                                      ? white
                                                                                      : Colors.green),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      todaysBookingMap['todayBookings'][index]
                                                                              [
                                                                              'status']
                                                                          .toString()
                                                                          .toUpperCase(),
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: todaysBookingMap['todayBookings'][index]['status'] ==
                                                                                "pending"
                                                                            ? Colors.grey
                                                                            : todaysBookingMap['todayBookings'][index]['status'] == "cancelled"
                                                                                ? Colors.red
                                                                                : todaysBookingMap['todayBookings'][index]['status'] == "completed"
                                                                                    ? white
                                                                                    : Colors.green,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    // "",
                                                    "# " +
                                                        todaysBookingMap[
                                                                'todayBookings']
                                                            [
                                                            index]['bookingId'],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: black
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  Text(
                                                    // "",
                                                    todaysBookingMap[
                                                                'todayBookings']
                                                            [
                                                            index]['userPhone'] ??
                                                        "",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: black
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  Builder(builder: (context) {
                                                    DateTime foo = DateTime
                                                        .parse(todaysBookingMap[
                                                                'todayBookings']
                                                            [index]['date']);
                                                    return Text(
                                                      // "",
                                                      "${_formatDate(foo)} - ${todaysBookingMap['todayBookings'][index]['time']}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: black,
                                                      ),
                                                    );
                                                  }),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    // "",
                                                    "Selected Services",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, indexssss) {
                                                      return Text(
                                                        "${indexssss + 1}. " +
                                                            todaysBookingMap[
                                                                            'todayBookings']
                                                                        [index][
                                                                    'serviceNames']
                                                                [indexssss],
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: black
                                                              .withOpacity(0.4),
                                                        ),
                                                      );
                                                    },
                                                    itemCount: todaysBookingMap[
                                                                'todayBookings']
                                                            [
                                                            index]['serviceNames']
                                                        .length,
                                                    shrinkWrap: true,
                                                  ),
                                                  Divider(),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          // "",
                                                          "₹ ${todaysBookingMap['todayBookings'][index]['totalAmount'].toString()}",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: black,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          todaysBookingMap['todayBookings']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'paymentMethod'] ==
                                                                  "cash_on_delivery"
                                                              ? "Pay after service"
                                                              : todaysBookingMap[
                                                                          'todayBookings']
                                                                      [index][
                                                                  'paymentMethod'],
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: primaryColor,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  todaysBookingMap['todayBookings']
                                                                      [index]
                                                                  ['status'] !=
                                                              "cancelled" ||
                                                          todaysBookingMap[
                                                                          'todayBookings']
                                                                      [index][
                                                                  'cancellReason'] ==
                                                              ""
                                                      ? SizedBox()
                                                      : SizedBox(
                                                          height: 10,
                                                        ),
                                                  todaysBookingMap['todayBookings']
                                                                      [index]
                                                                  ['status'] !=
                                                              "cancelled" ||
                                                          todaysBookingMap[
                                                                          'todayBookings']
                                                                      [index][
                                                                  'cancellReason'] ==
                                                              ""
                                                      ? SizedBox()
                                                      : Row(
                                                          children: [
                                                            Text(
                                                              "Cancel Reason: ",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                todaysBookingMap['todayBookings'][index]
                                                                            [
                                                                            'cancellReason'] ==
                                                                        null
                                                                    ? ""
                                                                    : todaysBookingMap['todayBookings']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'cancellReason'],
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  todaysBookingMap['todayBookings'].length,
                              shrinkWrap: true,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 15, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 60,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShimmerListHorii extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 15, // Adjust the count based on your needs
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 60,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShimmerListCAr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.3),
      highlightColor: Colors.grey[300]!,
      period: Duration(milliseconds: 600),
      child: CarouselSlider.builder(
        itemCount: 15,
        itemBuilder: (context, index, realIndex) {
          return Container(
            // height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(-1, 0),
                  blurRadius: 1,
                ),
              ],
              // border: Border.all(
              //     color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(10),
              // image: DecorationImage(
              //   image: NetworkImage(IMAGE_BASE_URL +
              //       banIma[index]["image"]),
              //   fit: BoxFit.fill,
              // ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "Loading...",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: white,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90)),
                        child: Transform.scale(
                          scale: 2.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: LinearProgressIndicator(
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90)),
                        child: Transform.scale(
                          scale: 2.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: LinearProgressIndicator(
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 155.0,

          // autoPlay: true,
          viewportFraction: 0.79,
          autoPlayCurve: Curves.easeInOutQuad,
          autoPlayInterval: Duration(
            seconds: 3,
          ),
          autoPlayAnimationDuration: Duration(
            milliseconds: 2200,
          ),
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
          // viewportFraction: 1,
          // height: 100,
          onPageChanged: (index, reason) {
            // setState(() {
            //   currentIndex = index;
            // });
          },
        ),
      ),
    );
  }
}
