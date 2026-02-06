import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/home.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/start_servic.dart';
import 'package:group_button/group_button.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Timer? timmm;

  TextEditingController searchCon = TextEditingController();
  String seating = "Pending";
  var seatingList = ["Pending", "Completed", "Cancelled"];

  DateTimeRange? _selectedDateRange;
  String _startDateString = '';
  String _endDateString = '';
  String _startDateStringFor = '';
  String _endDateStringFor = '';

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _startDateString = DateFormat('dd-MM-yyyy').format(picked.start);
        _endDateString = DateFormat('dd-MM-yyyy').format(picked.end);
        _startDateStringFor = _formatDate(picked.start);
        _endDateStringFor = _formatDate(picked.end);
      });
      getOrderHistory();
    }
  }

  Future getUserDetailforVen(chairID, timeID, orderId) async {
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

  // DateTime _selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(2015, 8),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  // }

  int val = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        val = 1;
      });
    });
    timmm = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    getOrderHistory();
  }

  @override
  void dispose() {
    super.dispose();
    timmm!.cancel();
  }

  Future getOrderHistory() async {
    print('$_startDateString - $_endDateString');
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/getorders/salon'));
    request.bodyFields = {
      'fromDate': '$_startDateString',
      'toDate': '$_endDateString',
      'status': seating.toLowerCase()
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        orderHisMap = decodedMap;
      });

      log(orderHisMap.toString());

      //orderHisMap
      // print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
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
          "Order History",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ),
      body: orderHisMap.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Color(0xFFF9F9F9),
                    //     ),
                    //     child: TextFormField(
                    //       decoration: InputDecoration(
                    //         border: InputBorder.none,
                    //         prefixIcon: Icon(
                    //           Icons.search,
                    //           size: 18,
                    //         ),
                    //         hintText: "Search",
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                padding: EdgeInsets.only(
                                    left: 12, right: 0, top: 0, bottom: 0),
                                isExpanded: true,
                                dropdownColor: white,
                                iconSize: 32,
                                style: TextStyle(color: black, fontSize: 16),
                                value: seating,
                                icon: Icon(
                                  Icons.expand_more,
                                  color: black,
                                  size: 25,
                                ),
                                items: seatingList.map((String? items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items!),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    seating = newValue!;
                                  });
                                  getOrderHistory();
                                },
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Bounce(
                        onTap: () {
                          _selectDateRange(context);
                        },
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF9F9F9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Builder(builder: (context) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(_startDateStringFor == ""
                                          ? "Select Range"
                                          : "Selected Range is ${_startDateStringFor} to ${_endDateStringFor}"),
                                    ),
                                    _startDateString == ""
                                        ? Icon(Icons.calendar_month)
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                _selectedDateRange = null;
                                                _startDateString = '';
                                                _endDateString = '';
                                                _startDateStringFor = '';
                                                _endDateStringFor = '';
                                              });
                                              getOrderHistory();
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                          ),
                                  ],
                                );
                              }),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Divider(
                  color: black.withOpacity(0.1),
                ),
                Expanded(
                  child: orderHisMap['bookings'].isEmpty
                      ? Center(child: Text("No data available"))
                      : Container(
                          color: white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: orderHisMap.isEmpty
                                ? ShimmerList()
                                : ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Slidable(
                                          endActionPane: orderHisMap['bookings']
                                                          [index]['status'] ==
                                                      "cancelled" ||
                                                  orderHisMap['bookings'][index]
                                                          ['status'] ==
                                                      "completed"
                                              ? null
                                              : ActionPane(
                                                  motion: BehindMotion(),
                                                  children: [
                                                    SlidableAction(
                                                      flex: 4,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      onPressed: (val) {
                                                        showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(40),
                                                              topRight: Radius
                                                                  .circular(40),
                                                            ),
                                                          ),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Padding(
                                                              padding: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets,
                                                              child: CancellReason(
                                                                  ifff: orderHisMap[
                                                                              'bookings']
                                                                          [
                                                                          index]
                                                                      ['_id']),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      backgroundColor:
                                                          Colors.red,
                                                      label: "Cancel",
                                                    ),
                                                  ],
                                                ),
                                          child: Bounce(
                                            onTap: () async {
                                              if (orderHisMap['bookings'][index]
                                                      ['status'] ==
                                                  'pending') {
                                                log(orderHisMap.toString());
                                                getUserDetailforVen(
                                                  orderHisMap['bookings'][index]
                                                      ['chairId'],
                                                  orderHisMap['bookings'][index]
                                                      ['timeid'],
                                                  orderHisMap['bookings'][index]
                                                      ['orderId'],
                                                );
                                              } else if (orderHisMap['bookings']
                                                      [index]['status'] ==
                                                  'started') {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return EndService(
                                                        iddd: orderHisMap[
                                                                'bookings']
                                                            [index]['_id'],
                                                      )
                                                          .animate()
                                                          .scale()
                                                          .shimmer();
                                                    });
                                              } else if (orderHisMap['bookings']
                                                      [index]['status'] ==
                                                  'cancelled') {
                                                Flushbar(
                                                    margin: EdgeInsets.all(6.0),
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                    textDirection:
                                                        Directionality.of(
                                                            context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                    title:
                                                        "Hey ${vendor_data['name']}",
                                                    message:
                                                        "This booking was cancelled!",
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 3))
                                                  ..show(context);
                                              } else {
                                                Flushbar(
                                                    margin: EdgeInsets.all(6.0),
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                    textDirection:
                                                        Directionality.of(
                                                            context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                    title:
                                                        "Hey ${vendor_data['name']}",
                                                    message:
                                                        "This booking was completed.",
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration:
                                                        Duration(seconds: 3))
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
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 12.0),
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: orderHisMap['bookings']
                                                                      [index][
                                                                  'userImage'] ==
                                                              ""
                                                          ? DecorationImage(
                                                              image:
                                                                  ExactAssetImage(
                                                                'assets/images/dummypic.png',
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                IMAGE_BASE_URL +
                                                                    orderHisMap['bookings']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'userImage'],
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                orderHisMap['bookings']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'userName'] ??
                                                                    "",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: black,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 8.0),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: orderHisMap['bookings'][index]
                                                                              [
                                                                              'status'] ==
                                                                          "pending"
                                                                      ? Colors
                                                                          .white
                                                                      : orderHisMap['bookings'][index]['status'] ==
                                                                              "cancelled"
                                                                          ? Colors
                                                                              .white
                                                                          : orderHisMap['bookings'][index]['status'] == "completed"
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
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              1),
                                                                      blurRadius:
                                                                          1,
                                                                      spreadRadius:
                                                                          1,
                                                                    ),
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .0),
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              1),
                                                                      blurRadius:
                                                                          1,
                                                                      spreadRadius:
                                                                          1,
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          4.0,
                                                                      vertical:
                                                                          3.0),
                                                                  child: Center(
                                                                    child: Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                8,
                                                                            width:
                                                                                8,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(90),
                                                                                color: orderHisMap['bookings'][index]['status'] == "pending"
                                                                                    ? Colors.grey
                                                                                    : orderHisMap['bookings'][index]['status'] == "cancelled"
                                                                                        ? Colors.red
                                                                                        : orderHisMap['bookings'][index]['status'] == "completed"
                                                                                            ? white
                                                                                            : Colors.green),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            orderHisMap['bookings'][index]['status'].toString().toUpperCase(),
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: orderHisMap['bookings'][index]['status'] == "pending"
                                                                                  ? Colors.grey
                                                                                  : orderHisMap['bookings'][index]['status'] == "cancelled"
                                                                                      ? Colors.red
                                                                                      : orderHisMap['bookings'][index]['status'] == "completed"
                                                                                          ? white
                                                                                          : Colors.green,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
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
                                                              orderHisMap['bookings']
                                                                      [index]
                                                                  ['bookingId'],
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: black
                                                                .withOpacity(
                                                                    0.4),
                                                          ),
                                                        ),
                                                        Text(
                                                          orderHisMap['bookings']
                                                                      [index][
                                                                  'userPhone'] ??
                                                              "",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: black
                                                                .withOpacity(
                                                                    0.4),
                                                          ),
                                                        ),
                                                        Builder(
                                                            builder: (context) {
                                                          DateTime foo = DateTime
                                                              .parse(orderHisMap[
                                                                      'bookings']
                                                                  [
                                                                  index]['date']);
                                                          return Text(
                                                            // "",
                                                            "${_formatDate(foo)} - ${orderHisMap['bookings'][index]['time']}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: black,
                                                            ),
                                                          );
                                                        }),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        // SizedBox(
                                                        //   height: 4,
                                                        // ),
                                                        Divider(),
                                                        Text(
                                                          // "",
                                                          "Selected Services",
                                                          style: GoogleFonts
                                                              .poppins(
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
                                                          itemBuilder: (context,
                                                              indexssss) {
                                                            return Text(
                                                              "${indexssss + 1}. " +
                                                                  orderHisMap['bookings']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'serviceNames']
                                                                      [
                                                                      indexssss],
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: black
                                                                    .withOpacity(
                                                                        0.4),
                                                              ),
                                                            );
                                                          },
                                                          itemCount: orderHisMap[
                                                                          'bookings']
                                                                      [index][
                                                                  'serviceNames']
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
                                                                "₹ ${orderHisMap['bookings'][index]['paymentTotalAmount'].toString()}",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: black,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                orderHisMap['bookings'][index]
                                                                            [
                                                                            'paymentMethod'] ==
                                                                        "cash_on_delivery"
                                                                    ? "Pay after service"
                                                                    : orderHisMap['bookings']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'paymentMethod'],
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
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        orderHisMap['bookings'][
                                                                            index]
                                                                        [
                                                                        'status'] !=
                                                                    "cancelled" ||
                                                                orderHisMap['bookings']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'cancellReason'] ==
                                                                    ""
                                                            ? SizedBox()
                                                            : SizedBox(
                                                                height: 10,
                                                              ),
                                                        orderHisMap['bookings'][
                                                                            index]
                                                                        [
                                                                        'status'] !=
                                                                    "cancelled" ||
                                                                orderHisMap['bookings']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'cancellReason'] ==
                                                                    ""
                                                            ? SizedBox()
                                                            : Row(
                                                                children: [
                                                                  Text(
                                                                    "Cancel Reason: ",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      orderHisMap['bookings'][index]
                                                                              [
                                                                              'cancellReason'] ??
                                                                          "",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w400,
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
                                                        MainAxisAlignment
                                                            .center,
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
                                    itemCount: orderHisMap['bookings'].length,
                                    shrinkWrap: true,
                                  ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class CancellReason extends StatefulWidget {
  String ifff;
  CancellReason({super.key, required this.ifff});

  @override
  State<CancellReason> createState() => _CancellReasonState();
}

class _CancellReasonState extends State<CancellReason> {
  String selectedOption = "";
  TextEditingController reason = TextEditingController();

  ScrollController _scrollController = ScrollController();

  // Function to scroll to the bottom
  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  //Cancell Reasons
  List<String> salonCancellationReasons = [
    "illness",
    "Emergency",
    "Weather",
    "Overbooked",
    "Unavailable",
    "Conflict",
    "Double-booked",
    "Unprepared",
    "Accident",
    "Breakdown",
    "Relocation",
    "Rescheduled",
    "Understaffed",
    "Unforeseen",
    "Maintenance",
    "Quarantine",
    "Lockdown",
    "Strike",
    "Holiday",
    "Delay",
    "Travel",
    "Family",
    "Work",
    "Meeting",
    "Childcare",
    "Event",
    "Injury",
    "Car",
    "Pet",
    "Traffic",
    "Others",
  ];

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

  Future cancelllBooking() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'PUT', Uri.parse('$BASE_URL/vendor/cancellbooking/${widget.ifff}'));
    request.bodyFields = {
      'cancellReason': selectedOption == "Others" ? reason.text : selectedOption
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      await getOrderHistory();
      await getTodaysBooking();
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

  Future getOrderHistory() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/getorders/salon'));
    request.bodyFields = {'fromDate': '', 'toDate': '', 'status': 'pending'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        orderHisMap = decodedMap;
      });

      Navigator.pop(context);

      //orderHisMap
      // print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        color: white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 6,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Select reason for cancellation",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    GroupButton(
                      options: GroupButtonOptions(
                          unselectedShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.01),
                              blurRadius: 0.0,
                              spreadRadius: 0,
                            ),
                          ],
                          selectedShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 0.5,
                              spreadRadius: 1,
                            ),
                          ],
                          selectedColor: primaryColor,
                          borderRadius: BorderRadius.circular(90),
                          mainGroupAlignment: MainGroupAlignment.start,
                          spacing: 4,
                          runSpacing: 2),
                      isRadio: true,
                      onSelected: (index, isSelected, _) {
                        setState(() {
                          selectedOption = index;
                          reason.clear();
                        });
                        if (selectedOption == "Others") {
                          return scrollToBottom();
                        }
                        print(selectedOption);
                      },
                      buttons: salonCancellationReasons,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    selectedOption != "Others"
                        ? SizedBox()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Please type your reason...",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: black.withOpacity(0.4),
                              ),
                            ),
                          ),
                    selectedOption != "Others"
                        ? SizedBox()
                        : SizedBox(
                            height: 10,
                          ),
                    selectedOption != "Others"
                        ? SizedBox()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: white.withOpacity(0.2),
                                ),
                                color: primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 5,
                              ),
                              child: TextFormField(
                                controller: reason,
                                maxLines: null,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: white.withOpacity(0.7),
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Please enter your reason...",
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: white.withOpacity(0.4),
                                    )),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Bounce(
              onTap: () {
                if (selectedOption == "") {
                  failed(
                      mesg: "Please a reason to cancel teh booking!",
                      context: context);
                } else {
                  if (selectedOption == "Others") {
                    if (reason.text == "") {
                      failed(
                          mesg:
                              "Please type your reason for cancellation or select from the provided option",
                          context: context);
                    } else {
                      cancelllBooking();
                    }
                  } else {
                    cancelllBooking();
                  }
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Cancel Booking",
                    style: GoogleFonts.poppins(
                      color: white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
