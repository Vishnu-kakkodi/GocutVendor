import 'dart:convert';
import 'dart:io';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/color/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

Map planHis = {};

class PlansHistory extends StatefulWidget {
  const PlansHistory({super.key});

  @override
  State<PlansHistory> createState() => _PlansHistoryState();
}

class _PlansHistoryState extends State<PlansHistory> {
  Future<void> _launchURL(urll) async {
    String url = urll;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    getPlanHist();
  }

  Future getPlanHist() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/vendorsubscribe/getallsubscribes'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        planHis = decodedMap;
      });
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
        title: InkWell(
          onTap: () {
            print(accessToken);
          },
          child: Text(
            "Plans History",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.history_outlined),
        //   )
        // ],
      ),
      body: planHis.isEmpty
          ? ShimmerList()
          : planHis['subscribeResult'].isEmpty
              ? Text("No plans were bought!")
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: Container(
                        // height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: secondaryColor.withOpacity(0.1),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(.25),
                          //     offset: Offset(1, 1),
                          //     blurRadius: 1,
                          //     spreadRadius: 1,
                          //   ),
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(.0),
                          //     offset: Offset(1, 1),
                          //     blurRadius: 1,
                          //     spreadRadius: 1,
                          //   )
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      planHis['subscribeResult'][index]
                                          ['planName'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: black,
                                      ),
                                    ),
                                    Builder(builder: (context) {
                                      // Parse the input date
                                      DateTime dateTime = DateTime.parse(
                                          planHis['subscribeResult'][index]
                                              ['startDate']);

                                      // Define the desired format
                                      String formattedDate =
                                          DateFormat('dd\'th\' MMMM yyyy')
                                              .format(dateTime);
                                      // Parse the input date
                                      DateTime dateTimee = DateTime.parse(
                                          planHis['subscribeResult'][index]
                                              ['endDate']);

                                      // Define the desired format
                                      String formattedDatee =
                                          DateFormat('dd\'th\' MMMM yyyy')
                                              .format(dateTimee);
                                      return Text(
                                        "$formattedDate - $formattedDatee",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          color: black,
                                        ),
                                      );
                                    }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "₹ " +
                                          planHis['subscribeResult'][index]
                                                  ['finalPrice']
                                              .toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "#" +
                                        planHis['subscribeResult'][index]
                                                ['transactionId']
                                            .toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Bounce(
                                    onTap: () {
                                      // print(planHis['subscribeResult'][index]
                                      //     ['subscribeInvoice']);
                                      _launchURL(IMAGE_BASE_URL +
                                          planHis['subscribeResult'][index]
                                              ['subscribeInvoice']);
                                      print(
                                          "print invoice url${IMAGE_BASE_URL + planHis['subscribeResult'][index]['subscribeInvoice']}");
                                      // generatePdf(context,
                                      //     planHis['subscribeResult'][index]);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                            color: black),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.download,
                                                color: white,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Invoice",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                  color: white,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  // separatorBuilder: (BuildContext context, int index) {
                  //   return Divider(
                  //     color: Colors.grey.withOpacity(0.2),
                  //   );
                  // },
                  itemCount: planHis['subscribeResult'].length,
                ),
    );
  }

  /* 
  
   final pdf = pw.Document();

    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );
  
  */

  void generatePdf(
    BuildContext context,
    Map indexDetails,
  ) async {
    EasyLoading.show();
    final pdf = pw.Document();

    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    // Parse the input dates
    DateTime startDate = DateTime.parse(indexDetails['startDate']!);
    DateTime endDate = DateTime.parse(indexDetails['endDate']!);

    // Define the desired format
    String formattedStartDate =
        DateFormat('dd\'th\' MMMM yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd\'th\' MMMM yyyy').format(endDate);

    // // Determine the footer color based on the plan name
    // PdfColor footerColor;
    // if (indexDetails['planName'] == 'Silver Plan' || indexDetails['planName'] == 'Sliver Plan') {
    //   footerColor = PdfColors.grey;
    // } else if (indexDetails['planName'] == 'Gold Plan') {
    //   footerColor = PdfColors.amber;
    // } else {
    //   footerColor =
    // }

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        build: (pw.Context context) {
          return pw.Container(
            color: PdfColor.fromInt(0xFFFAE5EA),
            child: pw.Stack(
              children: [
                pw.Positioned(
                  child: pw.Container(
                    color: PdfColor.fromInt(0xFFFAE5EA),
                    width: PdfPageFormat.a4.width,
                    height: PdfPageFormat.a4.height,
                  ),
                ),
                pw.Positioned(
                  top: 0,
                  left: 0,
                  child: pw.Container(
                    width: PdfPageFormat.a4.width,
                    height: 100,
                    color: PdfColor.fromInt(0xFFEDB9C7),
                  ),
                ),
                pw.Positioned(
                  top: 40,
                  left: 20,
                  child: pw.Text(
                    'Subscription Plan',
                    style: pw.TextStyle(
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                ),
                pw.Positioned(
                  top: 30,
                  right: 20,
                  child: pw.Image(logoImage, width: 100, height: 100),
                ),

                pw.Positioned(
                  top: 150,
                  right: -280,
                  child: pw.Container(
                    height: 500,
                    width: 500,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFF63183F),
                      borderRadius: pw.BorderRadius.circular(250),
                    ),
                  ),
                ),

                pw.Positioned(
                    top: 350,
                    right: -35,
                    child: pw.Transform.rotate(
                      angle: -3.14 / 2, // Rotate 90 degrees
                      child: pw.Text(
                        "Invoice",
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 80,
                        ),
                      ),
                    )),

                pw.Positioned(
                  top: 150,
                  left: 20,
                  child: pw.Container(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'GoCut\nVendor',
                          style: pw.TextStyle(
                            fontSize: 30,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromInt(0xFF63183F),
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          "# " + indexDetails['transactionId']!,
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColor.fromInt(0xFFEDB9C7),
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Plan Start Date:',
                          style: pw.TextStyle(
                              fontSize: 22, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          formattedStartDate,
                          style: pw.TextStyle(
                              fontSize: 15, color: PdfColors.blueGrey700),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'Plan End Date:',
                          style: pw.TextStyle(
                              fontSize: 22, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          formattedEndDate,
                          style: pw.TextStyle(
                              fontSize: 15, color: PdfColors.blueGrey700),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'Plan Name:',
                          style: pw.TextStyle(
                              fontSize: 22, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          indexDetails['planName']!,
                          style: pw.TextStyle(
                              fontSize: 15, color: PdfColors.blueGrey700),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          'Plan Price:',
                          style: pw.TextStyle(
                              fontSize: 22, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "Rs. " + indexDetails['finalPrice'].toString()!,
                          style: pw.TextStyle(
                              fontSize: 15, color: PdfColors.blueGrey700),
                        ),
                        pw.SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                pw.Positioned(
                  bottom: 150,
                  left: 20,
                  child: pw.Text(
                    'Billed to:',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Positioned(
                  bottom: 110,
                  left: 20,
                  child: pw.Text(
                    '${salon['name']}\n${salon['address']}',
                    style: pw.TextStyle(
                        fontSize: 12, color: PdfColors.blueGrey700),
                  ),
                ),
                pw.Positioned(
                  bottom: 130,
                  right: 20,
                  child: pw.Text(
                    'Payable to:',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Positioned(
                  bottom: 110,
                  right: 20,
                  child: pw.Text(
                    'GoCut House\nGachibowli, Hyderabad, 500032.',
                    style: pw.TextStyle(
                        fontSize: 12, color: PdfColors.blueGrey700),
                  ),
                ),
                // pw.Positioned(
                //   bottom: 100,
                //   right: 20,
                //   child: pw.Text(
                //     'Payment ID:',
                //     style: pw.TextStyle(
                //         fontSize: 12, fontWeight: pw.FontWeight.bold),
                //   ),
                // ),
                pw.Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: pw.Container(
                      height: 50,
                      color: PdfColor.fromInt(0xFFEDB9C7),
                      child: pw.Center(
                        child: pw.Text(
                          'Thank you for trusting us!',
                          style: pw.TextStyle(
                              fontSize: 12, color: PdfColors.black),
                        ),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );

    EasyLoading.dismiss();

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    // await OpenFile.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF Saved at ${file.path}')),
    );
  }
}
