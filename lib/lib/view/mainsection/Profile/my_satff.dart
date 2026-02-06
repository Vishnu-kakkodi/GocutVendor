import 'dart:async';
import 'dart:convert';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/add_staff.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class MyStaff extends StatefulWidget {
  String type;
  MyStaff({super.key, required this.type});

  @override
  State<MyStaff> createState() => _MyStaffState();
}

class _MyStaffState extends State<MyStaff> {
  int val = 0;

  Timer? timm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_staff(
        context,
        (reponse) => {
              setState(() {
                staff = reponse['staffs'];
              })
            });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        val = 1;
      });
    });
    timm = Timer.periodic(Duration(seconds: 1), (val) {
      setState(() {});
    });
    print(staff);
  }

  @override
  void dispose() {
    super.dispose();
    timm!.cancel();
  }

  Future deleteStaff(idddd) async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'DELETE', Uri.parse('$BASE_URL/vendor/staff/deletestaff/$idddd'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      await get_staff(
          context,
          (reponse) => {
                setState(() {
                  staff = reponse['staffs'];
                })
              });

      setState(() {});
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
      backgroundColor: white,
      appBar: widget.type == "mainsection"
          ? AppBar(
              backgroundColor: white,
              centerTitle: true,
              title: Text(
                "Staff Members",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            )
          : null,
      body: val == 0
          ? ShimmerList()
          : staff.isEmpty
              ? Center(
                  child: Text("No staff member has been added yet!"),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final item = staff[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 6.0, left: 10, right: 10),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: BehindMotion(),
                          children: [
                            SlidableAction(
                              spacing: 9,
                              flex: 4,
                              borderRadius: BorderRadius.circular(20),
                              onPressed: (val) {
                                print(item['_id']);
                                EasyLoading.show();
                                deleteStaff(item['_id']);
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
                              label: "Delete Staff",
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF77E7D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        IMAGE_BASE_URL + item['image'],
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
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Name",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ":",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "${item['name'] ?? ""}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Phone Number",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ":",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "${item['mobileNumber'] ?? ""}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                print("the -----> ${item}");
                                              },
                                              child: Text(
                                                "Gender",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ":",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "${item['gender'] ?? ""}",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Profession",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ":",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "${item['expertIn'] ?? ""}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: staff.length,
                  shrinkWrap: true,
                ),
      bottomNavigationBar: widget.type == "mainsection"
          ? Bounce(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddStaff()));
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
                      "Add Staff",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
