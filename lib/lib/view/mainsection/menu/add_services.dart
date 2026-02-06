import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/mainsection/menu/add_service_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:progressive_image/progressive_image.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  Timer? timer;

  int sectedIn = 0;
  int sectedSubIn = -1;

  List<TextEditingController> _controllers = [];
  List<TextEditingController> _controllers2 = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (val) {
      print('dsghjkl');
      setState(() {});
    });
    getServicesss();
  }

  void clearFields() {
    setState(() {
      prii = '';
      dissprii = '';
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future getServicesss() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/service/getallsubcategories'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        servicessssMap = decodedMap;
        subcatID = decodedMap['data'][0]['_id'];
      });
      getSupServices(decodedMap['data'][0]['_id']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getSupServices(iddd) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/service/getadminservices'));
    request.bodyFields = {'subcategoryId': iddd};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        subservicessssMap = decodedMap;
      });
      clearFields();
      // getSupServices(servicessssMap['data'][0]['_id']);
    } else {
      print(response.reasonPhrase);
    }
  }

  // Future getSupServices(iddd) async {
  //   var headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //     'Authorization': 'Bearer $accessToken'
  //   };
  //   var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           '$BASE_URL/vendor/service/getallvendorservices'));
  //   request.bodyFields = {'serviceId': iddd};
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var responseString = await response.stream.bytesToString();
  //     final decodedMap = json.decode(responseString);
  //     setState(() {
  //       subservicessssMap = decodedMap;
  //     });
  //     // getSupServices(servicessssMap['data'][0]['_id']);
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  String serID = "";
  String prii = '';
  String dissprii = '';
  String subcatID = '';

  TextEditingController prce = TextEditingController();
  TextEditingController disprce = TextEditingController();

  Future addServicesss() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/service/addvendorservice'));
    request.bodyFields = {
      'subcategoryId': subcatID,
      'serviceId': serID,
      'price': prii,
      'offerPrice': dissprii
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      setState(() {
        prii = '';
        dissprii = '';
      });
      getServices();
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
    }
  }

  Future getServices() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/service/getallvendorservices'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        addedServicesMap = decodedMap;
      });
      Navigator.pop(context);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        surfaceTintColor: white,
        elevation: 2,
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Add Services $prii",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        actions: [
          Align(
            child: Bounce(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddServiceMannual(),
                  ),
                );
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Colors.red.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.add_circle,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2.0,
                ),
              ],
            ),
            child: servicessssMap.isEmpty
                ? ShimmerList()
                : servicessssMap['data'].isEmpty
                    ? Text("No Data Available")
                    : ListView.builder(
                        itemCount: servicessssMap['data'].length,
                        itemBuilder: (context, index) {
                          final imageUrl = IMAGE_BASE_URL +
                              servicessssMap['data'][index]['image'];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Bounce(
                              onTap: () {
                                setState(() {
                                  sectedIn = index;
                                  subcatID =
                                      servicessssMap['data'][index]['_id'];
                                  sectedSubIn = -1;
                                  serID = "";
                                  prii = '';
                                  dissprii = '';
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                                clearFields();
                                getSupServices(
                                    servicessssMap['data'][index]['_id']);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: sectedIn == index ? white : null,
                                  gradient: sectedIn != index
                                      ? null
                                      : LinearGradient(
                                          colors: [
                                            white,
                                            Colors.red,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                ),
                                child: Align(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 700),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: ProgressiveImage(
                                              placeholder: AssetImage(
                                                  'assets/images/logo.png'),
                                              thumbnail: NetworkImage(imageUrl +
                                                  '?w=100&h=100&fit=blur'),
                                              image: CachedNetworkImageProvider(
                                                  imageUrl),
                                              fit: BoxFit.cover,
                                              fadeDuration:
                                                  Duration(milliseconds: 500),
                                              blur: 5,
                                              width: 220,
                                              height: 60,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        AutoSizeText(
                                          servicessssMap['data'][index]['name'],
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: sectedIn == index
                                                ? white
                                                : primaryColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: white,
                    child: subservicessssMap.isEmpty
                        ? ShimmerList()
                        : Align(
                            alignment: Alignment.topCenter,
                            child: subservicessssMap['data'].isEmpty
                                ? Center(
                                    child: Text(
                                        "No services available in the selected category"))
                                : ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Bounce(
                                          onTap: () {
                                            if (sectedSubIn == index) {
                                              setState(() {
                                                sectedSubIn = -1;
                                                serID = "";
                                              });
                                            } else {
                                              setState(() {
                                                sectedSubIn = index;
                                                serID =
                                                    subservicessssMap['data']
                                                        [index]['_id'];
                                              });
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: sectedSubIn == index
                                                  ? primaryColor
                                                  : white,
                                              boxShadow: [
                                                new BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 2.0,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: sectedSubIn == index
                                                        ? Icon(
                                                            LucideIcons
                                                                .checkSquare,
                                                            color: white,
                                                            size: 15,
                                                          )
                                                        : Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(sectedSubIn ==
                                                                                index
                                                                            ? 20
                                                                            : 0),
                                                                    border: sectedSubIn ==
                                                                            index
                                                                        ? null
                                                                        : Border
                                                                            .all(
                                                                            color:
                                                                                black,
                                                                          ),
                                                                    color: sectedSubIn ==
                                                                            index
                                                                        ? white
                                                                        : null),
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      subservicessssMap['data']
                                                          [index]['name'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color:
                                                            sectedSubIn == index
                                                                ? white
                                                                : black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                          color: sectedSubIn ==
                                                                  index
                                                              ? white
                                                              : black,
                                                        )),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 2.0),
                                                          child: TextFormField(
                                                            initialValue: prii,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onChanged: (val) {
                                                              setState(() {
                                                                prii = val;
                                                              });
                                                            },
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color:
                                                                  sectedSubIn ==
                                                                          index
                                                                      ? white
                                                                      : black,
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.only(
                                                                            bottom:
                                                                                15),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "Price",
                                                                    hintStyle:
                                                                        GoogleFonts
                                                                            .poppins(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: sectedSubIn ==
                                                                              index
                                                                          ? white
                                                                          : black,
                                                                    )),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                          color: sectedSubIn ==
                                                                  index
                                                              ? white
                                                              : black,
                                                        )),
                                                        child: TextFormField(
                                                          initialValue:
                                                              dissprii,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              dissprii = val;
                                                            });
                                                          },
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                sectedSubIn ==
                                                                        index
                                                                    ? white
                                                                    : black,
                                                          ),
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          bottom:
                                                                              15),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Discount Price",
                                                                  hintStyle:
                                                                      GoogleFonts
                                                                          .poppins(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: sectedSubIn ==
                                                                            index
                                                                        ? white
                                                                        : black,
                                                                  )),
                                                        ),
                                                      )
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
                                    itemCount: subservicessssMap['data'].length,
                                    shrinkWrap: true,
                                  ),
                          ),
                  ),
                ),
                sectedSubIn != -1
                    ? Bounce(
                        onTap: () {
                          /*
                          
                            String serID = "";
        String prii = '';
        String dissprii = '';
                          
                           */

                          if (serID == "") {
                            failed(
                                mesg: "Please select a service",
                                context: context);
                            return;
                          }

                          if (prii == "") {
                            failed(
                                mesg: "Please enter price for selected service",
                                context: context);
                            return;
                          }

                          if (dissprii == "") {
                            failed(
                                mesg:
                                    "Please enter discount price for selected service",
                                context: context);
                            return;
                          }

                          addServicesss();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Add services",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
