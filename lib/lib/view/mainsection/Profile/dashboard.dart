import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateee = DateFormat('yyyy-MM-dd').format(now);
    getDashboard();
  }

  Future getDashboard() async {
    print("get all dashboad${accessToken}");
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/gevendordashboard'));

    request.bodyFields = {'fromDate': dateee, 'toDate': dateee};
    request.headers.addAll(headers);
    print("get all dashboad${request.body}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print("get all dashboad${decodedMap}");
      setState(() {
        dasboardMap = decodedMap;
      });
      log(dasboardMap.toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  DateTime selectedDate = DateTime.now();
  String dateee = "";

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: primaryColor,
          ),
        ),
      ),
      body: dasboardMap.isEmpty
          ? Center(child: Text("Loading.. Please wait"))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            "My Activity",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                  dateee = DateFormat('yyyy-MM-dd')
                                      .format(selectedDate);
                                });
                                getDashboard();
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  isSameDay(selectedDate, DateTime.now())
                                      ? "Today"
                                      : DateFormat('dd MMM, yyyy')
                                          .format(selectedDate),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Icon(
                                  LucideIcons.chevronDown,
                                  color: white,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: white,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      white,
                                      Color(0xFF80D1CB).withOpacity(0.4),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Total\nAppointments",
                                          style: GoogleFonts.poppins(
                                            color: black,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 0.0),
                                  child: Text(
                                    "${dasboardMap['dashboardData']['totalBookings']}",
                                    style: GoogleFonts.poppins(
                                      color: black,
                                      fontSize: 45,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: -5,
                                child: Image.asset(
                                  'assets/images/scehudels.png',
                                  height: 70,
                                  width: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: white,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      white,
                                      Color(0xFFFDC741).withOpacity(0.4),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Total\nEarnings",
                                          style: GoogleFonts.poppins(
                                            color: black,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 5.0),
                                  child: Text(
                                    "${dasboardMap['dashboardData']['totalAmount']}",
                                    style: GoogleFonts.poppins(
                                      color: black,
                                      fontSize: 35,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: -5,
                                child: Image.asset(
                                  'assets/images/earning.png',
                                  height: 70,
                                  width: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Most Booking Services",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showBottomBorder: true,
                                dividerThickness: 0,
                                columnSpacing:
                                    10, // Adjust the space between columns
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 14.0, left: 4.0),
                                      child: Text(
                                        'S.no',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 14.0, left: 4.0),
                                      child: Text(
                                        'Service',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 14.0, left: 14.0),
                                      child: Text(
                                        'Actual Price',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 14.0, left: 14.0),
                                      child: Text(
                                        'Offer Price',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List.generate(
                                  dasboardMap['dashboardData']
                                          ['mostBookedServiceData']
                                      .length,
                                  (index) {
                                    Color backgroundColor = index % 2 == 0
                                        ? Colors.white
                                        : Color(0xfff9f9f9);

                                    return DataRow(
                                      color: MaterialStateProperty.resolveWith<
                                          Color>((Set<MaterialState> states) {
                                        return backgroundColor;
                                      }),
                                      cells: <DataCell>[
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 14.0, left: 4.0),
                                            child: Builder(builder: (context) {
                                              return Center(
                                                child: Text(
                                                  '${index + 1}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 14.0, left: 4.0),
                                            child: Builder(builder: (context) {
                                              return Center(
                                                child: Text(
                                                  dasboardMap['dashboardData'][
                                                          'mostBookedServiceData']
                                                      [index]['name'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 14.0, left: 14.0),
                                            child: Builder(builder: (context) {
                                              return Center(
                                                child: Text(
                                                  "₹ ${dasboardMap['dashboardData']['mostBookedServiceData'][index]['price']}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 14.0, left: 14.0),
                                            child: Builder(builder: (context) {
                                              return Center(
                                                child: Text(
                                                  "₹ ${dasboardMap['dashboardData']['mostBookedServiceData'][index]['offerPrice']}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
