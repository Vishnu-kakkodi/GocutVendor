import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/add_combo.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';

class MyCombos extends StatefulWidget {
  const MyCombos({super.key});

  @override
  State<MyCombos> createState() => _MyCombosState();
}

class _MyCombosState extends State<MyCombos> {
  Timer? timmmmm;

  @override
  void initState() {
    super.initState();
    get_combos(context, (response) {
      setState(() {
        combos_list = response['vendorcombos'];
      });
    });
    timmmmm = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timmmmm!.cancel();
  }

  Future deleteCombo(idddd) async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'DELETE', Uri.parse('$BASE_URL/vendor/combo/deletecombo/$idddd'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);

      get_combos(context, (response) {
        setState(() {
          combos_list = response['vendorcombos'];
        });
      });
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
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
        title: Bounce(
          onTap: () {
            log(accessToken);
          },
          child: Text(
            "My Combos",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(),
          Expanded(
            child: combos_list.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      final item = combos_list[index];
                      return Stack(
                        children: [
                          CampaignCard(
                            campaign: Campaign(
                              name: combos_list[index]['comboName'],
                              category: "",
                              // combos_list[index]['categoryName'],
                              service: combos_list[index]['serviceName'],
                              description: combos_list[index]['description'],
                              startDate: combos_list[index]['startDate'],
                              endDate: combos_list[index]['endDate'],
                              serviceValue: combos_list[index]['serviceValue'].toString(),
                              discountValue: combos_list[index]['comboPrice'].toString(),
                              image: combos_list[index]['image'] ?? "",
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Bounce(
                              onTap: () {
                                deleteCombo(combos_list[index]['_id']);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  color: Colors.red,
                                ),
                                child: Icon(
                                  Icons.delete_forever,
                                  color: white,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: combos_list.length,
                    shrinkWrap: true,
                  )
                : Center(
                    child: Text("No Combos Available"),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Bounce(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCombo()));
        },
        child: BottomAppBar(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: primaryColor,
            ),
            child: Center(
              child: Text(
                "Add Combo",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Campaign {
  final String? name;
  final String? category;
  final String? service;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String? serviceValue;
  final String? discountValue;
  final String? image;

  Campaign({
    @required this.name,
    @required this.category,
    @required this.service,
    @required this.description,
    @required this.startDate,
    @required this.endDate,
    @required this.serviceValue,
    @required this.discountValue,
    @required this.image,
  });
}

class CampaignCard extends StatelessWidget {
  final Campaign? campaign;

  CampaignCard({@required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      surfaceTintColor: white,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   'Combo Type: ${campaign!.name}',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18.0,
            //   ),
            // ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Combo Type: ',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: black)),
                  TextSpan(
                      text: campaign!.name,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: black)),
                ],
              ),
            ),
            // SizedBox(height: 10.0),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //           text: 'Category: ',
            //           style: GoogleFonts.poppins(
            //               fontSize: 13,
            //               fontWeight: FontWeight.w600,
            //               color: black)),
            //       TextSpan(
            //           text: '${campaign!.category}',
            //           style: GoogleFonts.poppins(
            //               fontSize: 14,
            //               fontWeight: FontWeight.w400,
            //               color: black)),
            //     ],
            //   ),
            // ),
            SizedBox(height: 10.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Service: ',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: black)),
                  TextSpan(
                      text: '${campaign!.service}',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: black)),
                ],
              ),
            ),

            SizedBox(height: 10.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Description: ',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: black)),
                  TextSpan(
                      text: campaign!.description,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: black)),
                ],
              ),
            ),
            // Text(
            //   'Description: ${campaign!.description}',
            //   style: TextStyle(fontSize: 16.0),
            // ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // SizedBox(width: 10.0),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              NetworkImage(IMAGE_BASE_URL + campaign!.image!))),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Service Value: ',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: black)),
                            TextSpan(
                                text: campaign!.serviceValue,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: black)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Combo Value: ',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: black)),
                            TextSpan(
                                text: campaign!.discountValue,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: black)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'End Date: ',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: black)),
                            TextSpan(
                                text: campaign!.endDate,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: black)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Start Date: ',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: black)),
                            TextSpan(
                                text: campaign!.startDate,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // AutoSizeText(
                  //   'End Date: ${campaign!.endDate}',
                  //   style: TextStyle(fontSize: 16.0),
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
