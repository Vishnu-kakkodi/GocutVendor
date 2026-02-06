import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/controllers/bottomNavigation_controller.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:gocut_vendor/lib/view/mainsection/menu/add_services.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatefulWidget {
  String type;
  MenuScreen({super.key, required this.type});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int val = 0;

  Timer? asy;

  @override
  void initState() {
    asy = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
    getServices();
  }

  @override
  void dispose() {
    super.dispose();
    asy!.cancel();
  }

  Future getServices() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/service/getallvendorservices'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        addedServicesMap = decodedMap;
      });
    } else {
      EasyLoading.dismiss();
      print(response.reasonPhrase);
    }
  }

  Future deleteService(idd) async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request('DELETE',
        Uri.parse('$BASE_URL/vendor/service/deletevendorservice/$idd'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      await getServices();
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

  final _bottomNavigationController = Get.find<BottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.type == "mainsection"
            ? _bottomNavigationController.updateSelectedIndex(0)
            : null;

        return widget.type == "mainsection" ? false : true;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: widget.type == "mainsection"
            ? AppBar(
                backgroundColor: white,
                centerTitle: true,
                title: Bounce(
                  onTap: () {
                    log(accessToken + "    ${vendor_data['_id']}");
                  },
                  child: Text(
                    "Services",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            : widget.type == "profile"
                ? AppBar(
                    leading: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back)),
                    backgroundColor: white,
                    centerTitle: true,
                    title: Bounce(
                      onTap: () {
                        log(accessToken + "    ${vendor_data['_id']}");
                      },
                      child: Text(
                        "Services",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                : null,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: addedServicesMap.isEmpty
              ? ShimmerList()
              : addedServicesMap['services'].isEmpty
                  ? Center(child: Text("No services were added previously"))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: white,
                                          boxShadow: [
                                            new BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 18.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.cut,
                                                color: primaryColor,
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  addedServicesMap['services']
                                                          [index]['name'] ??
                                                      addedServicesMap[
                                                              'services'][index]
                                                          ['serviceName'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                addedServicesMap['services']
                                                        [index]['price']
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                addedServicesMap['services']
                                                        [index]['offerPrice']
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Bounce(
                                      onTap: () {
                                        showDeleteConfirmationDialog(
                                            context,
                                            addedServicesMap['services'][index]
                                                    ['name'] ??
                                                addedServicesMap['services']
                                                    [index]['serviceName'],
                                            addedServicesMap['services'][index]
                                                ['_id']);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          color: white,
                                          boxShadow: [
                                            new BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 2.0,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            itemCount: addedServicesMap['services'].length,
                            shrinkWrap: true,
                          )
                        ],
                      ),
                    ),
        ),
        bottomNavigationBar: Bounce(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddServices()));
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
                  "Add Services",
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
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, String name, String iddddd) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete $name service?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                EasyLoading.show();
                await deleteService(iddddd);
                // Perform the deletion operation here
                // For example:
                // deleteService();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
