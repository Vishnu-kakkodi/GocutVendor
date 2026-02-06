import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:bounce/bounce.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

String formatTimeOfDay(TimeOfDay time) {
  String period = time.period == DayPeriod.am ? 'AM' : 'PM';
  int hour = time.hourOfPeriod;
  if (hour == 0) {
    hour = 12;
  }
  String hourStr = hour
      .toString()
      .padLeft(2, '0'); // Ensure leading zero for single-digit hours
  String minute = time.minute.toString().padLeft(2, '0');
  return '$hourStr:$minute $period';
}

class EditSlots extends StatefulWidget {
  const EditSlots({super.key});

  @override
  State<EditSlots> createState() => _EditSlotsState();
}

class _EditSlotsState extends State<EditSlots> {
  int selectedCha = 0;
  String selectedChaID = "";

  String chairID = "";

  Timer? timm;

  @override
  void initState() {
    super.initState();
    selectedDay = getCurrentDayIndex();
    getChairs();
    getSeatLimitData();
    timm = Timer.periodic(Duration(seconds: 1), (val) {
      setState(() {});
    });
  }

  int getCurrentDayIndex() {
    DateTime now = DateTime.now();
    switch (now.weekday) {
      case DateTime.monday:
        return 0;
      case DateTime.tuesday:
        return 1;
      case DateTime.wednesday:
        return 2;
      case DateTime.thursday:
        return 3;
      case DateTime.friday:
        return 4;
      case DateTime.saturday:
        return 5;
      case DateTime.sunday:
        return 6;
      default:
        return -1; // Just a safety fallback, should never hit this
    }
  }

  @override
  void dispose() {
    super.dispose();
    timm!.cancel();
  } 

  Future addChair() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/slot/chair/addchair'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      getChairs();
      getSlotsBookings();
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

  Future getChairs() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/slot/chair/getallchairs'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print("get seats and chairs${chairsMap}");
      setState(() {
        chairsMap = decodedMap;
        selectedCha = 0;
        selectedChaID = chairsMap['chairs'][0]['_id'];
      });
      Future.delayed(Duration(seconds: 1), () {
        addandgetSlots(
            chairsMap['chairs'].isEmpty ? "" : chairsMap['chairs'][0]['_id']);
      });
    } else if (response.statusCode == 404) {
      setState(() {
        chairsMap.clear();
        selectedCha = 0;
      });
      getSlotsBookings();
      Future.delayed(Duration(seconds: 1), () {
        addandgetSlots(
            chairsMap['chairs'].isEmpty ? "" : chairsMap['chairs'][0]['_id']);
      });
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

  Future deleteChair(idd) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'DELETE', Uri.parse('$BASE_URL/vendor/slot/chair/deltechair/$idd'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      getChairs();
      getSlotsBookings();
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
      print(response.reasonPhrase);
    }
  }

  Future addandgetSlots(chaiID) async {
    print(BASE_URL);
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/slot/getallslots'));
    request.bodyFields = {'chairId': chaiID};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print("get all dates${decodedMap}");
      setState(() {
        chairsSlotsMap = decodedMap;

        sess1 = chairsSlotsMap['slots'][selectedDay]['session1'];
        sess2 = chairsSlotsMap['slots'][selectedDay]['session2'];
        durrr = TextEditingController(
            text: chairsSlotsMap['slots'][selectedDay]['duration'] == null
                ? "60"
                : chairsSlotsMap['slots'][selectedDay]['duration']);
        dayID = chairsSlotsMap['slots'][selectedDay]['_id'];
        _session1startTime = null;
        _session1endTime = null;
        _session2startTime = null;
        _session2endTime = null;
      });
      print("get slots data${decodedMap}");
      getSlotsBookings();
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

  int selectedDay = -1;
  TextEditingController durrr = TextEditingController();

  TimeOfDay? _session1startTime;
  TimeOfDay? _session1endTime;

  // Future<void> _selectTime(BuildContext context, bool isStartTime) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: isStartTime
  //         ? (_session1startTime ?? TimeOfDay.now())
  //         : (_session1endTime ?? TimeOfDay.now()),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isStartTime) {
  //         _session1startTime = picked;
  //         _selectTime(context, false);
  //       } else {
  //         _session1endTime = picked;
  //       }
  //     });
  //   }
  // }

  String _helpText = "Select Start Time";

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    bool validTimeSelected = false;

    while (!validTimeSelected) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        hourLabelText: "Hour",
        minuteLabelText: "Minute",
        helpText: _helpText,
        initialTime: isStartTime
            ? (_session1startTime ?? TimeOfDay.now())
            : (_session1endTime ??
                _getNextTime(_session1startTime ?? TimeOfDay.now())),
      );

      if (picked != null) {
        if (isStartTime) {
          setState(() {
            _session1startTime = picked;
            _session1endTime = _getNextTime(picked); // Reset end time
            _helpText = "Select End Time";
          });
          validTimeSelected = true;
          // Automatically call the picker for the end time
          await _selectTime(context, false);
        } else {
          if (_session1startTime != null) {
            final startMinutes =
                _session1startTime!.hour * 60 + _session1startTime!.minute;
            final endMinutes = picked.hour * 60 + picked.minute;
            final minEndMinutes =
                startMinutes + 60; // 15 minutes after start time

            if (endMinutes < minEndMinutes) {
              setState(() {
                _helpText =
                    'End time must be at least 60 minutes after the start time.';
              });
            } else {
              setState(() {
                _session1endTime = picked;
                _helpText = "Time Selected";
                validTimeSelected = true;
              });
            }
          }
        }
      } else {
        // If the user cancels the picker, break the loop
        validTimeSelected = true;
      }
    }
  }

  TimeOfDay _getNextTime(TimeOfDay time) {
    final totalMinutes = time.hour * 60 + time.minute + 60;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours % 24, minute: minutes);
  }

  TimeOfDay? _session2startTime;
  TimeOfDay? _session2endTime;

  String sess1 = "";
  String sess2 = "";

  String dayID = "";

  Future<void> _selectTime2(BuildContext context, bool isStartTime) async {
    bool validTimeSelected = false;

    while (!validTimeSelected) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        hourLabelText: "Hour",
        minuteLabelText: "Minute",
        helpText: _helpText,
        initialTime: isStartTime
            ? (_session2startTime ?? TimeOfDay.now())
            : (_session2endTime ??
                _getNextTime(_session2startTime ?? TimeOfDay.now())),
      );

      if (picked != null) {
        if (isStartTime) {
          setState(() {
            _session2startTime = picked;
            _session2endTime = _getNextTime(picked); // Reset end time
            _helpText = "Select End Time";
          });
          validTimeSelected = true;
          // Automatically call the picker for the end time
          await _selectTime2(context, false);
        } else {
          if (_session2startTime != null) {
            final startMinutes =
                _session2startTime!.hour * 60 + _session2startTime!.minute;
            final endMinutes = picked.hour * 60 + picked.minute;
            final minEndMinutes =
                startMinutes + 60; // 15 minutes after start time

            if (endMinutes < minEndMinutes) {
              setState(() {
                _helpText =
                    'End time must be at least 60 minutes after the start time.';
              });
            } else {
              setState(() {
                _session2endTime = picked;
                _helpText = "Time Selected";
                validTimeSelected = true;
              });
            }
          }
        }
      } else {
        // If the user cancels the picker, break the loop
        validTimeSelected = true;
      }
    }
  }

  int _seatLimitCount = 0;
  Future getSeatLimitData() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/admin/setting/getall'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      _seatLimitCount = decodedMap['contactus']['seatLimit'];
      print("seata limit count${_seatLimitCount}");
      // failed(mesg: decodedMap['message'], context: context);
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

  // Future<void> _selectTime2(BuildContext context, bool isStartTime) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: isStartTime
  //         ? (_session2startTime ?? TimeOfDay.now())
  //         : (_session2endTime ?? TimeOfDay.now()),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       if (isStartTime) {
  //         _session2startTime = picked;
  //         _selectTime2(context, false);
  //       } else {
  //         _session2endTime = picked;
  //       }
  //     });
  //   }
  // }

  Future updateSlots(idddd) async {
    // print("print time 2${_session2startTime}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'PUT', Uri.parse('$BASE_URL/vendor/slot/chair/updatesessions/$idddd'));
    request.body = (_session2startTime == null && sess2 == "")
        ? json.encode({
            "session1": _session1startTime == null
                ? sess1
                : (formatTimeOfDay(_session1startTime!) +
                    "-" +
                    formatTimeOfDay(_session1endTime!)),
            "duration": durrr.text
          })
        : json.encode({
            "session1": _session1startTime == null
                ? sess1
                : (formatTimeOfDay(_session1startTime!) +
                    "-" +
                    formatTimeOfDay(_session1endTime!)),
            "session2": _session2startTime == null
                ? sess2
                : (formatTimeOfDay(_session2startTime!) +
                    "-" +
                    formatTimeOfDay(_session2endTime!)),
            "duration": durrr.text
          });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      getSlotsBookings();
      Navigator.pop(context);
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
    }
  }

  bool updateAllSlots = false;

  Future updateAllDaysSlots(chaiID) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'PUT', Uri.parse('$BASE_URL/vendor/slot/update/sessionbasedonchairId'));
    request.body = (_session2startTime == null && sess2 == "")
        ? json.encode({
            "chairId": chaiID,
            "session1": _session1startTime == null
                ? sess1
                : (formatTimeOfDay(_session1startTime!) +
                    "-" +
                    formatTimeOfDay(_session1endTime!)),
            "duration": durrr.text
          })
        : json.encode({
            "chairId": chaiID,
            "session1": _session1startTime == null
                ? sess1
                : (formatTimeOfDay(_session1startTime!) +
                    "-" +
                    formatTimeOfDay(_session1endTime!)),
            "session2": _session2startTime == null
                ? sess2
                : (formatTimeOfDay(_session2startTime!) +
                    "-" +
                    formatTimeOfDay(_session2endTime!)),
            "duration": durrr.text
          });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("get all days body${request.body}");
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      getSlotsBookings();
      Navigator.pop(context);
      Navigator.pop(context);
      // setState(() {});
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

  Future getSlotsBookings() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/slot/getallvendorslots'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("Hitttttibg,,,,,,,");

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        slotsMapdata = decodedMap;
      });
      // getSlotsBookings();
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
          "Edit Slots",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            child: chairsSlotsMap.isEmpty
                ? Center(
                    child: Text(
                    "Please add a seat first and continue the process",
                    style: GoogleFonts.poppins(
                      color: black.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ))
                : Column(
                    children: [
                      Container(
                        height: 70,
                        width: double.infinity,
                        child: chairsSlotsMap['slots'].isEmpty
                            ? Text(
                                "Please add a seat first and continue the process")
                            : Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ListView.builder(
                                  itemCount: chairsSlotsMap['slots'].length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Align(
                                      child: Bounce(
                                        onTap: () {
                                          setState(() {
                                            selectedDay = index;
                                            sess1 = chairsSlotsMap['slots']
                                                [index]['session1'];
                                            sess2 = chairsSlotsMap['slots']
                                                [index]['session2'];
                                            durrr = TextEditingController(
                                                text: chairsSlotsMap['slots']
                                                                [index]
                                                            ['duration'] ==
                                                        null
                                                    ? "60"
                                                    : chairsSlotsMap['slots']
                                                        [index]['duration']);
                                            dayID = chairsSlotsMap['slots']
                                                [index]['_id'];
                                            _session1startTime = null;
                                            _session1endTime = null;
                                            _session2startTime = null;
                                            _session2endTime = null;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          height: 60,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectedDay == index
                                                ? primaryColor
                                                : Colors.white,
                                            border: Border.all(
                                                color: selectedDay == index
                                                    ? white
                                                    : Colors.black
                                                        .withOpacity(0.3)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              chairsSlotsMap['slots'][index]
                                                  ['dayName'],
                                              style: GoogleFonts.poppins(
                                                color: selectedDay == index
                                                    ? white
                                                    : black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                      selectedDay == -1
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Bounce(
                                      onTap: () async {
                                        /*
                                        
                                            "chairId": "$chaiID",
      "duration": durrr.text,
      "session1": formatTimeOfDay(_session1startTime!) +
          "-" +
          formatTimeOfDay(_session1endTime!),
      "session2": formatTimeOfDay(_session2startTime!) +
          "-" +
          formatTimeOfDay(_session2endTime!),
                                        
                                         */

                                        if ((_session1endTime == null &&
                                                sess1.split('-')[0] == "") ||
                                            (_session1startTime == null &&
                                                sess1.split('-')[1] == "")) {
                                          failed(
                                              mesg:
                                                  "Please select first time slot",
                                              context: context);
                                        } else if (durrr.text == "") {
                                          failed(
                                              mesg: "Enter Duration for slots",
                                              context: context);
                                        } else {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(40),
                                                topRight: Radius.circular(40),
                                              ),
                                            ),
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext context) {
                                              return Padding(
                                                  padding:
                                                      MediaQuery.of(context)
                                                          .viewInsets,
                                                  child: applyToAkll());
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                            colors: [
                                              primaryColor,
                                              primaryColor.withOpacity(0.9)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  primaryColor.withOpacity(0.5),
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            ),
                                            BoxShadow(
                                              color:
                                                  primaryColor.withOpacity(0.3),
                                              blurRadius: 30,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors
                                                .amberAccent, // Vibrant contrasting color for highlight
                                            width: 2.5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                "Apply to all days",
                                                style: GoogleFonts.poppins(
                                                  fontSize:
                                                      16, // Larger font for extra emphasis
                                                  fontWeight: FontWeight
                                                      .w600, // Bold weight for readability
                                                  color: Colors.white,
                                                  letterSpacing:
                                                      0.5, // Slight letter spacing for elegance
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset: Offset(1, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Switch(
                                  //     value: updateAllSlots,
                                  //     onChanged: (val) async {
                                  // EasyLoading.show();
                                  // await updateAllDaysSlots(selectedChaID);
                                  //     }),
                                ],
                              ),
                            ),
                      Expanded(
                        child: selectedDay == -1
                            ? Center(
                                child: Text(
                                    "Please select a day to get slots data"))
                            : Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Duration",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ":",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.black26,
                                                      )),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 3,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.red,
                                                      ),
                                                      controller: durrr,
                                                      decoration:
                                                          InputDecoration(
                                                              counterText: "",
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "Enter duration",
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                      readOnly: true,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Session 1",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ":",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Bounce(
                                                  onTap: () {
                                                    print(_session1startTime
                                                            .toString() +
                                                        " " +
                                                        _session1endTime
                                                            .toString());
                                                    // print(sess1.split('-')[1]);
                                                    _selectTime(context, true);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        )),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 5,
                                                              bottom: 5),
                                                      child:
                                                          _session1startTime ==
                                                                  null
                                                              ? Text(
                                                                  sess1 == ""
                                                                      ? "Please select session 1 slots"
                                                                      : sess1,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  formatTimeOfDay(
                                                                          _session1startTime!) +
                                                                      " to " +
                                                                      formatTimeOfDay(
                                                                          _session1endTime!),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Session 2",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ":",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: black,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Bounce(
                                                  onTap: () {
                                                    print(_session1startTime
                                                            .toString() +
                                                        " " +
                                                        _session2endTime
                                                            .toString());
                                                    _selectTime2(context, true);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        )),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              top: 5,
                                                              bottom: 5),
                                                      child: _session2endTime ==
                                                              null
                                                          ? Text(
                                                              sess2 == ""
                                                                  ? "Please select session 2 slots"
                                                                  : sess2,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : Text(
                                                              formatTimeOfDay(
                                                                      _session2startTime!) +
                                                                  " to " +
                                                                  formatTimeOfDay(
                                                                      _session2endTime!),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  dayID == ""
                                      ? Bounce(
                                          onTap: () {
                                            if (dayID == "") {
                                              failed(
                                                  mesg:
                                                      "Please select day first",
                                                  context: context);
                                              return;
                                            }
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            color: Colors.transparent,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                      )
                    ],
                  ),
          )),
          Container(
            height: 70,
            color: Color(0xFFF5F7F8),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Align(
                  child: RippleAnimation(
                    color: primaryColor,
                    delay: const Duration(milliseconds: 300),
                    repeat: true,
                    minRadius: 25,
                    ripplesCount: 6,
                    duration: const Duration(milliseconds: 6 * 300),
                    child: Bounce(
                      scaleFactor: 0.62,
                      onTap: () {
                        if (_seatLimitCount == chairsMap['chairs'].length) {
                          failed(
                              mesg:
                                  "You can not add more than${_seatLimitCount} seats",
                              context: context);
                        } else {
                          addChair();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(90),
                            color: white),
                        child: Center(
                          child: Icon(
                            Icons.add_circle,
                            size: 48,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.withOpacity(0.3),
                  indent: 3,
                  endIndent: 3,
                ),
                Expanded(
                  child: chairsMap.isEmpty
                      ? ShimmerListHorii()
                      : chairsMap['chairs'].isEmpty
                          ? Center(child: Text('Please add chair!'))
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 60,
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      Bounce(
                                        onTap: () {
                                          setState(() {
                                            selectedChaID = chairsMap['chairs']
                                                [index]['_id'];
                                            selectedCha = index;
                                            // selectedDay = -1;
                                          });
                                          addandgetSlots(chairsMap['chairs']
                                              [index]['_id']);
                                          log(chairsMap['chairs'][index]
                                              .toString());
                                        },
                                        child: Center(
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: selectedCha == index
                                                  ? primaryColor
                                                  : white,
                                            ),
                                            child: Align(
                                              child: Image.asset(
                                                'assets/images/salooncha.png',
                                                height: 40,
                                                color: selectedCha == index
                                                    ? null
                                                    : Colors.grey
                                                        .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Bounce(
                                          onTap: () {
                                            deleteChair(
                                              chairsMap['chairs'][index]['_id'],
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5),
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                                color: Colors.red,
                                                border: Border.all(
                                                  width: 2,
                                                  color: Color(0xFFF5F7F8),
                                                )),
                                            child: Icon(
                                              Icons.close,
                                              color: white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Bounce(
                                          onTap: () {
                                            // deleteChair(
                                            //   chairsMap['chairs'][index]['_id'],
                                            // );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                                color: selectedCha == index
                                                    ? Colors.green
                                                    : Colors.grey,
                                                border: Border.all(
                                                  width: 2,
                                                  color: Color(0xFFF5F7F8),
                                                )),
                                            child: Center(
                                              child: Text(
                                                chairsMap['chairs'][index]
                                                        ['chairNumber']
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: chairsMap['chairs'].length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                            ),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Bounce(
        scaleFactor: 0.62,
        child: BottomAppBar(
          surfaceTintColor: white,
          child: Bounce(
            onTap: () {
              if ((_session1endTime == null && sess1.split('-')[0] == "") ||
                  (_session1startTime == null && sess1.split('-')[1] == "")) {
                failed(
                    mesg: "Select Session 1 Time to update", context: context);
              }

              // else if (_session2endTime == null ||
              //     _session2startTime == null) {
              //   failed(
              //       mesg: "Select Session 2 Time to update", context: context);
              // } else if (durrr.text == "") {
              //   failed(mesg: "Add duration as well", context: context);
              // }

              else {
                EasyLoading.show();
                updateSlots(dayID);
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
                  "Update Slots",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  applyToAkll() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 280),
      child: Container(
        height: 190,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: white,
        ),
        child: BlurryContainer(
          blur: 5,
          shadowColor: Colors.black26,
          width: MediaQuery.of(context).size.width,
          height: 200,
          elevation: 0,
          color: Colors.transparent,
          padding: const EdgeInsets.all(8),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: Stack(
            children: [
              Positioned.fill(
                child: FloatingBubbles(
                  noOfBubbles: 10,
                  colorsOfBubbles: [
                    Colors.blue,
                    primaryColor,
                    secondaryColor,
                    thirdColor
                  ],
                  sizeFactor: 0.16,
                  duration: 420, // 120 seconds.
                  opacity: 50,
                  paintingStyle: PaintingStyle.fill,
                  strokeWidth: 8,
                  shape: BubbleShape
                      .circle, // circle is the default. No need to explicitly mention if its a circle.
                  speed: BubbleSpeed.normal, // normal is the default
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Are you sure?",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Are you certain you want to apply the selected time slots for each day to the currently selected day? This would mean that all days will have the same time slots as the one you have currently set.",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Bounce(
                            scaleFactor: 1.4,
                            onTap: () {
                              Navigator.pop(context);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SupportScreen(),
                              //   ),
                              // );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.3),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: Align(
                                child: BlurryContainer(
                                    blur: 2,
                                    height: 50,
                                    borderRadius: BorderRadius.circular(90),
                                    width: double.infinity,
                                    child: Center(
                                      child: Text("No! Just Checking.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Bounce(
                            scaleFactor: 1.4,
                            onTap: () async {
                              EasyLoading.show();
                              await updateAllDaysSlots(selectedChaID);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: black.withOpacity(0.3),
                                  width: 2,
                                ),
                                color: white,
                                borderRadius: BorderRadius.circular(90),
                              ),
                              child: BlurryContainer(
                                  blur: 2,
                                  height: 50,
                                  borderRadius: BorderRadius.circular(90),
                                  width: double.infinity,
                                  child: Center(
                                    child: Text("Yes! Im Sure.",
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  )),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
