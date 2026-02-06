import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/global/data.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/add_disconunts.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/editDiscount.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyDiscounts extends StatefulWidget {
  const MyDiscounts({super.key});

  @override
  State<MyDiscounts> createState() => _MyDiscountsState();
}

class _MyDiscountsState extends State<MyDiscounts> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      return setState(() {});
    });
    super.initState();

    setState(() {
      all_campaings = [];
    });
    get_capaings(context, (response) {
      setState(() {
        all_campaings = response['vendorcampaigns'];
      });
      print("the dtle data  : ${all_campaings}");
    });

    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "My Discounts",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(),
          Expanded(
            child: all_campaings.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      final item = all_campaings[index];
                      return CampaignCard(
                        campaign: Campaign(
                          id: item['_id'],
                          name: item['campaignName'] ?? "",
                          service: item['serviceName'] ?? "",
                          description: item['description'] ?? "",
                          startDate: item['startDate'] ?? "",
                          endDate: item['endDate'] ?? "",
                          serviceValue: item['serviceValue'].toString(),
                          discountValue: item['discount'].toString(),
                          image: item['image'] ?? "",
                          category: "",

                          //item['categoryName'] ??
                        ),
                      );
                    },
                    itemCount: all_campaings.length,
                    shrinkWrap: true,
                  )
                : Center(child: Text("No Discounts Available")),
          ),
        ],
      ),
      bottomNavigationBar: Bounce(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDiscounts()));
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
                "Add Discount",
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
  final String? service;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String? serviceValue;
  final String? discountValue;
  final String? category;
  final String? id;
  final String? image;

  Campaign({
    @required this.id,
    @required this.name,
    @required this.service,
    @required this.description,
    @required this.startDate,
    @required this.endDate,
    @required this.serviceValue,
    @required this.category,
    @required this.discountValue,
    @required this.image,
  });
}

class CampaignCard extends StatefulWidget {
  final Campaign? campaign;

  CampaignCard({@required this.campaign});

  @override
  State<CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends State<CampaignCard> {
  camps() async {
    print("the camps res: called");
    EasyLoading.show();
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '$BASE_URL/vendor/campaign/getallvendorcampaigns?searchQuery='));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("the camps res: ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        all_campaings = decodedMap['vendorcampaigns'];
      });
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      surfaceTintColor: white,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Campaign Name ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: black,
                        ),
                      ),
                    ),
                    Text(
                      ':',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${widget.campaign!.name}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w200,
                          fontSize: 14.0,
                          color: black,
                        ),
                      ),
                    ),

                    // IconButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => EditDiscount(
                    //                   discount:
                    //                       widget.campaign!.discountValue.toString(),
                    //                   disc: widget.campaign!.description.toString(),
                    //                   e_date: widget.campaign!.endDate.toString(),
                    //                   id: widget.campaign!.id.toString(),
                    //                   name: widget.campaign!.name.toString(),
                    //                   s_date: widget.campaign!.startDate.toString(),
                    //                   s_val:
                    //                       widget.campaign!.serviceValue.toString(),
                    //                   serv_name:
                    //                       widget.campaign!.service.toString())));
                    //     },
                    //     icon: Icon(
                    //       Icons.edit,
                    //       color: green,
                    //     )),
                    // IconButton(
                    //     onPressed: () async {
                    //       print("the all camo ${all_campaings}");
                    //       await delete(context, widget.campaign!.id);
                    //       camps();
                    //     },
                    //     icon: Icon(
                    //       Icons.delete,
                    //       color: red,
                    //     ))
                  ],
                ),
                SizedBox(height: 10.0),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: Text(
                //         'Category ',
                //         style: GoogleFonts.poppins(
                //           fontWeight: FontWeight.w500,
                //           fontSize: 14.0,
                //           color: black,
                //         ),
                //       ),
                //     ),
                //     Text(
                //       ':',
                //       style: GoogleFonts.poppins(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 14.0,
                //         color: black,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: Text(
                //         '${widget.campaign!.category}',
                //         style: GoogleFonts.poppins(
                //           fontWeight: FontWeight.w200,
                //           fontSize: 14.0,
                //           color: black,
                //         ),
                //       ),
                //     ),

                //     // IconButton(
                //     //     onPressed: () {
                //     //       Navigator.push(
                //     //           context,
                //     //           MaterialPageRoute(
                //     //               builder: (context) => EditDiscount(
                //     //                   discount:
                //     //                       widget.campaign!.discountValue.toString(),
                //     //                   disc: widget.campaign!.description.toString(),
                //     //                   e_date: widget.campaign!.endDate.toString(),
                //     //                   id: widget.campaign!.id.toString(),
                //     //                   name: widget.campaign!.name.toString(),
                //     //                   s_date: widget.campaign!.startDate.toString(),
                //     //                   s_val:
                //     //                       widget.campaign!.serviceValue.toString(),
                //     //                   serv_name:
                //     //                       widget.campaign!.service.toString())));
                //     //     },
                //     //     icon: Icon(
                //     //       Icons.edit,
                //     //       color: green,
                //     //     )),
                //     // IconButton(
                //     //     onPressed: () async {
                //     //       print("the all camo ${all_campaings}");
                //     //       await delete(context, widget.campaign!.id);
                //     //       camps();
                //     //     },
                //     //     icon: Icon(
                //     //       Icons.delete,
                //     //       color: red,
                //     //     ))
                //   ],
                // ),
                // SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Service ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: black,
                        ),
                      ),
                    ),
                    Text(
                      ':',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${widget.campaign!.service}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w200,
                          fontSize: 14.0,
                          color: black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Description ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: black,
                        ),
                      ),
                    ),
                    Text(
                      ':',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: black,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${widget.campaign!.description}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w200,
                          fontSize: 14.0,
                          color: black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  IMAGE_BASE_URL + widget.campaign!.image!))),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Service Value ',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: black,
                                  ),
                                ),
                              ),
                              Text(
                                ':',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${widget.campaign!.serviceValue!}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14.0,
                                    color: black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Discount Value ',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: black,
                                  ),
                                ),
                              ),
                              Text(
                                ':',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${widget.campaign!.discountValue}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14.0,
                                    color: black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Builder(builder: (context) {
                            // Parse the string to DateTime object
                            DateTime dateTime = DateTime.parse(
                                widget.campaign!.startDate.toString());

                            // Format the date to display only the date portion
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(dateTime);

                            return RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Start Date: ',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: formattedDate,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14.0,
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // AutoSizeText(
                            //   'Start Date: $formattedDate',
                            //   style: TextStyle(fontSize: 16.0),
                            // );
                          }),
                          SizedBox(
                            height: 10,
                          ),
                          Builder(builder: (context) {
                            // Parse the string to DateTime object
                            DateTime dateTime2 = DateTime.parse(
                                widget.campaign!.endDate.toString());

                            // Format the date to display only the date portion
                            String formattedDate2 =
                                DateFormat('yyyy-MM-dd').format(dateTime2);
                            return RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'End Date: ',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: formattedDate2,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14.0,
                                      color: black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // AutoSizeText(
                            //   'End Date: $formattedDate2',
                            //   style: TextStyle(fontSize: 16.0),
                            // );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'option1',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit',
                          style: GoogleFonts.poppins(
                            color: black,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'option2',
                    child: ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: Text('Delete',
                          style: GoogleFonts.poppins(
                            color: black,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                ];
              },
              onSelected: (String value) async {
                // Handle the selected option
                switch (value) {
                  case 'option1':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditDiscount(
                                catee: "",
                                // widget.campaign!.category.toString(),
                                discount:
                                    widget.campaign!.discountValue.toString(),
                                disc: widget.campaign!.description.toString(),
                                e_date: widget.campaign!.endDate.toString(),
                                id: widget.campaign!.id.toString(),
                                name: widget.campaign!.name.toString(),
                                s_date: widget.campaign!.startDate.toString(),
                                s_val: widget.campaign!.serviceValue.toString(),
                                discountImage:
                                    widget.campaign!.image.toString(),
                                serv_name:
                                    widget.campaign!.service.toString())));
                    break;
                  case 'option2':
                    await delete(context, widget.campaign!.id);
                    camps();
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
