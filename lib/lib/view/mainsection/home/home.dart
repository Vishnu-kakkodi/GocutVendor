import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bounce/bounce.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/constants/constant.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/edit_slots.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/gallery.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/my_satff.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/profile.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/salon_profile.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:gocut_vendor/lib/view/mainsection/mainsection.dart';
import 'package:gocut_vendor/lib/view/mainsection/menu/menu.dart';
import 'package:http/http.dart' as http;
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/notifications_scr.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/start_servic.dart';
import 'package:gocut_vendor/lib/view/mainsection/home/wallet_scr.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Map slotDetailsMap = {};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool swithc = false;
  // final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  List imagesss = [
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  ];

  int seleedddCat = 0;
  Timer? timee;
  ScrollController _scrollController = ScrollController();
  int _current_index_date_home = 0;
  String _selected_date_to_pass_details = '';

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    _selected_date_to_pass_details =
        DateFormat('yyyy-MM-dd').format(currentDate);
    print("get seleccted date${_selected_date_to_pass_details}");

    timee = Timer.periodic(Duration(seconds: 1), (val) {
      setState(() {});
    });
    get_wallet(context, (response) {
      setState(() {
        wallet_data = response;
      });
      print(wallet_data);
    });
    getNotiStatus();
    Future.delayed(Duration(seconds: 2), () {
      getBanners();
      getSlotsBookings();
      getServices();
      getStoreStatus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timee!.cancel();
  }

  bool compareTime(String selectedTimeString, String passedday) {
    // Parse the passedday date
    final selectedDate = DateTime.parse(passedday);

    // Get the current date
    final nowDate = DateTime.now();

    print(
        "The selected date ${DateFormat('yyyy-MM-dd').format(nowDate)} today, so compare the ${passedday}");

    // Compare the dates
    if (DateFormat('yyyy-MM-dd').format(nowDate).toString() == passedday) {
      print("The selected date is today, so compare the time");
      //
      final List<String> parts = selectedTimeString.split(' ');
      final List<String> timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (parts[1] == 'PM' && hour < 12) {
        hour += 12;
      } else if (parts[1] == 'AM' && hour == 12) {
        hour = 0;
      }

      final selectedTime = TimeOfDay(hour: hour, minute: minute);
      final now = TimeOfDay.now();
      final nowMinutes = now.hour * 60 + now.minute;
      final selectedMinutes = selectedTime.hour * 60 + selectedTime.minute;

      if (selectedMinutes > nowMinutes) {
        return true; // The selected time is in the future.
      } else {
        return false; // The selected time has passed or is the current time.
      }
    } else if (selectedDate.isAfter(nowDate)) {
      // The selected date is in the future
      return true;
    } else {
      return false;
    }
  }

  Future getStoreStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/salon/getsalonstorestatus'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        storSta = decodedMap['store_status'];
      });

      if (datttt == false) if (storSta == false) {
        Flushbar(
            margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 65),
            flushbarStyle: FlushbarStyle.FLOATING,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            title: "Hey ${vendor_data['name']}",
            message:
                "Your store ${salon['name']} is set to offline note that the store wont be able to get any bookings while it is in offline state",
            backgroundColor: Colors.red.shade800,
            duration: Duration(seconds: 6))
          ..show(context);
        setState(() {
          datttt = true;
        });
      } else {
        Flushbar(
            margin: EdgeInsets.all(6.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            title: "Hey ${vendor_data['name']}",
            message:
                "Your store ${salon['name']} is set to online.\nEnjoy your day!",
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3))
          ..show(context);
        setState(() {
          datttt = true;
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getStoreStatusss() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/salon/getsalonstorestatus'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        storSta = decodedMap['store_status'];
      });

      if (storSta == false) {
        Flushbar(
            margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 65),
            flushbarStyle: FlushbarStyle.FLOATING,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            title: "Hey ${vendor_data['name']}",
            message:
                "Your store ${salon['name']} is set to offline note that the store wont be able to get any bookings while it is in offline state",
            backgroundColor: Colors.red.shade800,
            duration: Duration(seconds: 6))
          ..show(context);
        setState(() {
          datttt = true;
        });
      } else {
        Flushbar(
            margin: EdgeInsets.all(6.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            title: "Hey ${vendor_data['name']}",
            message:
                "Your store ${salon['name']} is set to online.\nEnjoy your day!",
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3))
          ..show(context);
        setState(() {
          datttt = true;
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future updateStoreStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'PUT', Uri.parse('$BASE_URL/vendor/salon/updatestorestatus'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    // print("gfudvbdwfkjenkld");

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      getStoreStatusss();
      getStoreStatus();
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getNotiStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request('POST',
        Uri.parse('$BASE_URL/vendor/notification/getnotificationstatus'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        getNotiSta = decodedMap['vendor']['notification_bell'];
      });
      //
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getBanners() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk$accessToken");
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/vendorbanners'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        bannersMap = decodedMap;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getSlotsBookings() async {
    var headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/slot/getallvendorslots'));
    request.body = json.encode({
      "slotDate": _selected_date_to_pass_details,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        slotsMapdata = decodedMap;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future activeSeat({required String slotId, required BuildContext}) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'PUT', Uri.parse('$BASE_URL/vendor/slot/activeInactiveSlot'));
    request.bodyFields = {'slotId': slotId};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      getSlotsBookings();

      // print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getSlotStatus(chairID, timeID, dayID, orderId) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/vendor/slot/booking/status'));
    request.bodyFields = {
      'dayId': '$dayID',
      'timeid': '$timeID',
      'chairId': '$chairID'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      print("slot timings date${decodedMap}");
      if (decodedMap['status'] == 'pending') {
        getUserDetailforVen(chairID, timeID, orderId);
      } else if (decodedMap['status'] == 'started') {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return EndService(
                iddd: decodedMap['booking']['_id'],
              ).animate().scale().shimmer();
            });
      } else if (decodedMap['status'] == 'cancelled') {
        Flushbar(
            margin: EdgeInsets.all(6.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            title: "Hey ${vendor_data['name']}",
            message: "Selected time slots booking was cancelled",
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3))
          ..show(context);
      } else {
        Flushbar(
            margin: EdgeInsets.all(6.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            title: "Hey ${vendor_data['name']}",
            message: "Selected time slots booking was completed",
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3))
          ..show(context);
      }
    } else if (response.statusCode == 404) {
      EasyLoading.showError("No booking were made for this slot yet!");
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getUserDetailforVen(chairID, timeID, orderId) async {
    print("fdfkfjkdjfkd");
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
    print("time id cheiaid or id${request.body}");

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      print("get all statr itme data${decodedMap}");
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
    } else {
      print(response.reasonPhrase);
    }
  }


  String resolveImageUrl(String image) {
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return image; // full URL from API
  }
  return IMAGE_BASE_URL + image; // multer / relative path
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitDialog(context);
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext) {
                    return SalonProfile();
                  }));
                  // showNotification();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: white,
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 10.0,
                      ),
                    ],
                    image: DecorationImage(
                        image: NetworkImage(
                          salon.isEmpty
                              ? "https://images.pexels.com/photos/19896879/pexels-photo-19896879/free-photo-of-harbor-in-stockholm-sweden.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                              : IMAGE_BASE_URL + salon['logo'],
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Bounce(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => LocationHomeScreen()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salon.isEmpty ? "Loading..." : salon['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        salon.isEmpty ? "Loading..." : salon['address'],
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: white.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8, // Adjust this value to scale the switch size

                child: Switch(
                    activeColor: Colors.green,
                    activeTrackColor: Colors.white,
                    value: storSta,
                    onChanged: (val) {
                      updateStoreStatus();
                      // setState(() {
                      //   swithc = !swithc;
                      // });
                    }),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              Align(
                child: Bounce(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Wallet_Screen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 30,
                    width: wallet_data['wallet'].toString().length >= 6
                        ? 100
                        : wallet_data['wallet'].toString().length > 4
                            ? 80
                            : 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: white.withOpacity(0.3),
                    ),
                    child: Align(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.wallet,
                            color: white,
                            size: 22,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          wallet_data.isEmpty
                              ? Expanded(
                                  child: AutoSizeText(
                                    "loading...",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      color: white,
                                      fontSize: 1,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : Expanded(
                                  child: AutoSizeText(
                                    "₹ " + wallet_data['wallet'].toString(),
                                    style: GoogleFonts.poppins(
                                      color: white,
                                      fontSize: 12,
                                    ),
                                    minFontSize:
                                        8, // Ensure text is readable if very small
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Bounce(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: white.withOpacity(0.3),
                  ),
                  child: Icon(
                    Icons.notifications_on,
                    color: white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SlidingUpPanel(
            color: Colors.transparent,
            maxHeight: MediaQuery.of(context).size.height - 180,
            minHeight: MediaQuery.of(context).size.height - 365,
            panel: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: white),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                      height: 30,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Bounce(
                              scaleFactor: 1.3,
                              onTap: () {
                                seleedddCat = 0;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        seleedddCat == 0 ? primaryColor : white,
                                    border: Border.all(
                                      color: seleedddCat == 0
                                          ? primaryColor.withOpacity(0.4)
                                          : black,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage('assets/images/slots.png'),
                                        size: 15,
                                        color: seleedddCat == 0
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Center(
                                          child: Text(
                                            'Slots',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: seleedddCat == 0
                                                  ? white
                                                  : black,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Bounce(
                              scaleFactor: 1.3,
                              onTap: () {
                                seleedddCat = 1;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        seleedddCat == 1 ? primaryColor : white,
                                    border: Border.all(
                                      color: seleedddCat == 1
                                          ? primaryColor.withOpacity(0.4)
                                          : black,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage(
                                            'assets/images/services.png'),
                                        size: 15,
                                        color: seleedddCat == 1
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Center(
                                          child: Text(
                                            'Services',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: seleedddCat == 1
                                                  ? white
                                                  : black,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Bounce(
                              scaleFactor: 1.3,
                              onTap: () {
                                seleedddCat = 2;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        seleedddCat == 2 ? primaryColor : white,
                                    border: Border.all(
                                      color: seleedddCat == 2
                                          ? primaryColor.withOpacity(0.4)
                                          : black,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage('assets/images/gallery.png'),
                                        size: 15,
                                        color: seleedddCat == 2
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Center(
                                          child: Text(
                                            'Gallery',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: seleedddCat == 2
                                                  ? white
                                                  : black,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Bounce(
                              scaleFactor: 1.3,
                              onTap: () {
                                seleedddCat = 3;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        seleedddCat == 3 ? primaryColor : white,
                                    border: Border.all(
                                      color: seleedddCat == 3
                                          ? primaryColor.withOpacity(0.4)
                                          : black,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage('assets/images/staff.png'),
                                        size: 15,
                                        color: seleedddCat == 3
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Center(
                                          child: Text(
                                            'Staff',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: seleedddCat == 3
                                                  ? white
                                                  : black,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Bounce(
                            //   onTap: () {
                            //     seleedddCat = 4;
                            //   },
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(5),
                            //         color:
                            //             seleedddCat == 4 ? primaryColor : white,
                            //         border: Border.all(
                            //           color: seleedddCat == 4
                            //               ? primaryColor.withOpacity(0.4)
                            //               : black,
                            //         )),
                            //     child: Padding(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 8.0, vertical: 2.0),
                            //       child: Row(
                            //         children: [
                            //           ImageIcon(
                            //             AssetImage('assets/images/slots.png'),
                            //             size: 15,
                            //             color: seleedddCat == 4
                            //                 ? Colors.white
                            //                 : Colors.grey,
                            //           ),
                            //           SizedBox(
                            //             width: 5,
                            //           ),
                            //           Padding(
                            //             padding:
                            //                 const EdgeInsets.only(bottom: 2.0),
                            //             child: Center(
                            //               child: Text(
                            //                 'Direction',
                            //                 style: GoogleFonts.poppins(
                            //                   fontSize: 13,
                            //                   color: seleedddCat == 4
                            //                       ? white
                            //                       : black,
                            //                 ),
                            //               ),
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 6,
                    decoration:
                        BoxDecoration(color: thirdColor.withOpacity(0.2)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 86,
                      child: Column(
                        children: [
                          Container(
                            height: 86,
                            child: Scrollbar(
                              radius: Radius.circular(6),
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: 7, // Limit to 7 days
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime currentDate = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day + index,
                                  );
                                  return GestureDetector(
                                    onTap: () async {
                                      // setState(() {
                                      _current_index_date_home = index;
                                      // _selected_day_details =
                                      //     "${DateFormat('dd').format(currentDate)}";
                                      _selected_date_to_pass_details =
                                          "${DateFormat('yyyy-MM-dd').format(currentDate)}";

                                      getSlotsBookings();

                                      // print(
                                      //     "get seleccted date${_selected_date_to_pass_details}");
                                      //   apiData.storeSlotDateid(
                                      //       _selected_date_to_pass_details);
                                      // _scrollToSelectedIndex();
                                      // });

                                      // await apiData.clearchairAndSeatSelection();
                                      // guestLogin
                                      //     ? null
                                      //     : await Provider.of<
                                      //                 SlotBookingController>(
                                      //             context,
                                      //             listen: false)
                                      //         .displayCart(
                                      //             context: context,
                                      //             salonId: widget.salonId);

                                      // if (apiData
                                      //         .getDisplayCartChairAndSeatSelection
                                      //         .isNotEmpty &&
                                      //     (apiData.getDisplayCartChairAndSeatSelection[
                                      //             0]['slotDate'] ==
                                      //         _selected_date_to_pass_details)) {
                                      //   // [0]['slotDate']

                                      //   await apiData
                                      //       .togglechairAndSeatSelectionAddFromCart(
                                      //           apiData
                                      //               .getDisplayCartChairAndSeatSelection);
                                      // }

                                      // await apiData.updateSlotDateIfExists(
                                      //     0, _selected_date_to_pass_details);

                                      // await Provider.of<SlotBookingController>(
                                      //         context,
                                      //         listen: false)
                                      //     .fetchChairsAndSlots(
                                      //         context: context,
                                      //         salonId: widget.salonId,
                                      //         subCategoryId: "",
                                      //         slotDate:
                                      //             _selected_date_to_pass_details);

                                      // print(
                                      //     "Selected Day: --->> ${_selected_date_to_pass_details}");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 9, bottom: 15, top: 5),
                                      child: Container(
                                        height: 48,
                                        width: 53,
                                        decoration: BoxDecoration(
                                            color: _current_index_date_home ==
                                                    index
                                                ? primaryColor
                                                : white,
                                            border: Border.all(
                                                color:
                                                    _current_index_date_home ==
                                                            index
                                                        ? primaryColor
                                                        : blue),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${DateFormat('MMM').format(currentDate)}",
                                              style: TextStyle(
                                                  fontFamily: "IntR",
                                                  fontSize: 13,
                                                  color:
                                                      _current_index_date_home ==
                                                              index
                                                          ? white
                                                          : black.withOpacity(
                                                              0.8)),
                                            ),
                                            Text(
                                              "${DateFormat('dd').format(currentDate)}",
                                              style: TextStyle(
                                                  fontFamily: "IntR",
                                                  fontSize: 13,
                                                  color:
                                                      _current_index_date_home ==
                                                              index
                                                          ? white
                                                          : black.withOpacity(
                                                              0.8)),
                                            ),
                                            Text(
                                              "${DateFormat('E').format(currentDate)}",
                                              style: TextStyle(
                                                  fontFamily: "IntR",
                                                  fontSize: 13,
                                                  color:
                                                      _current_index_date_home ==
                                                              index
                                                          ? white
                                                          : black.withOpacity(
                                                              0.8)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: seleedddCat == 0
                        ? slotsMapdata.isEmpty
                            ? ShimmerList()
                            : Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Row(
                                        children: [
                                          slotsMapdata.isEmpty
                                              ? SizedBox()
                                              : slotsMapdata['chairs'].isEmpty
                                                  ? SizedBox()
                                                  : Expanded(
                                                      child: Text(
                                                          "Available Seats",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                    ),
                                          slotsMapdata['chairs'].isEmpty
                                              ? SizedBox()
                                              : Bounce(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditSlots(),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      color: primaryColor,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit,
                                                            color: white,
                                                            size: 14,
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text("Edit Slots",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          slotsMapdata['chairs'].isEmpty
                                              ? SizedBox()
                                              : Bounce(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditSlots(),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      color: primaryColor,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.add,
                                                            color: white,
                                                            size: 14,
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text("Add Seat",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      height: 20,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: 3,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                          color: index == 0
                                                              ? green
                                                              : index == 1
                                                                  ? black
                                                                      .withOpacity(
                                                                          0.3)
                                                                  : primaryColor),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        index == 0
                                                            ? "Available"
                                                            : index == 1
                                                                ? "Not Available"
                                                                : "Booked",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        )),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // SizedBox(
                                        //   width: 16,
                                        // ),
                                        // Container(
                                        //   height: 20,
                                        //   width: 20,
                                        //   decoration: BoxDecoration(
                                        //       // shape: BoxShape.circle,
                                        //       color: black.withOpacity(0.3)),
                                        // ),
                                        // SizedBox(
                                        //   width: 10,
                                        // ),
                                        // Text("Not Available",
                                        //     style: GoogleFonts.poppins(
                                        //       color: black,
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w400,
                                        //     )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: Container(
                                        // height: MediaQuery.of,
                                        child: slotsMapdata.isEmpty
                                            ? ShimmerList()
                                            : slotsMapdata['chairs'].isEmpty
                                                ? Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 148.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "No chairs added\nPlease add chair first",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color: black,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        18.0),
                                                            child: Bounce(
                                                              scaleFactor: 0.62,
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EditSlots(),
                                                                  ),
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color:
                                                                      primaryColor,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Add Chairs",
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    itemCount:
                                                        slotsMapdata['chairs']
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Bounce(
                                                          onTap: () {
                                                            log(slotsMapdata[
                                                                    'chairs']
                                                                [index]['_id']);
                                                          },
                                                          child: Container(
                                                            width: 150,
                                                            height: 250,
                                                            decoration: BoxDecoration(
                                                                color: white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                boxShadow: [
                                                                  new BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.3),
                                                                    blurRadius:
                                                                        2.0,
                                                                  ),
                                                                ]),
                                                            child: Stack(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        activeSeat(
                                                                            BuildContext:
                                                                                context,
                                                                            slotId:
                                                                                slotsMapdata['chairs'][index]['_id']);
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            'assets/images/chair_ena.png',
                                                                            height:
                                                                                100,
                                                                            color: slotsMapdata['chairs'][index]['isActive']
                                                                                ? green
                                                                                : black.withOpacity(0.3),
                                                                            width:
                                                                                100,
                                                                          ),
                                                                          Text(
                                                                            "Seat ${slotsMapdata['chairs'][index]['chairNumber']}",
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          Divider(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: slotsMapdata['chairs'][index]['timings']
                                                                              .isEmpty
                                                                          ? Center(
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: Text(
                                                                                  "You have not defined slots for this chair",
                                                                                  style: GoogleFonts.poppins(
                                                                                    color: black.withOpacity(0.4),
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : ListView
                                                                              .builder(
                                                                              itemBuilder: (context, subbindex) {
                                                                                // Parsing the time string into a DateTime object
                                                                                String timeString = slotsMapdata['chairs'][index]['timings'][subbindex]['time'];
                                                                                DateTime slotTime = DateFormat("h:mm a").parse(timeString);

                                                                                // Getting the current time
                                                                                DateTime now = DateTime.now();

                                                                                // Setting the slot time to today's date with the parsed time
                                                                                slotTime = DateTime(now.year, now.month, now.day, slotTime.hour, slotTime.minute);

                                                                                // Comparing the slot time with the current time
                                                                                bool isPast = compareTime(timeString, _selected_date_to_pass_details);

                                                                                // bool isPast = slotTime.isBefore(now);
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(4.0),
                                                                                  child: Bounce(
                                                                                    onTap: () {
                                                                                      log(slotsMapdata['chairs'][index]['timings'][subbindex]['_id']);

                                                                                      if (!isPast) {
                                                                                        failed(mesg: "The time slot is past time\nCan not perform any functionality on this time slot", context: context);
                                                                                      } else {
                                                                                        if (slotsMapdata['chairs'][index]['timings'][subbindex]['isBooked'] == false) {
                                                                                          EasyLoading.showError("No booking were made for this slot yet!");
                                                                                          //[subbindex]['_id']
                                                                                        } else {
                                                                                          EasyLoading.show();
                                                                                          getSlotStatus(
                                                                                            slotsMapdata['chairs'][index]['chairId'],
                                                                                            slotsMapdata['chairs'][index]['timings'][subbindex]['_id'],
                                                                                            slotsMapdata['chairs'][index]['dayId'],
                                                                                            slotsMapdata['chairs'][index]['timings'][subbindex]['orderId'],
                                                                                          );
                                                                                          // getUserDetailforVen(slotsMapdata['chairs'][index]['chairId'], slotsMapdata['chairs'][index]['timings'][subbindex]['_id']);
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                        color: (!isPast || !slotsMapdata['chairs'][index]['isActive'])
                                                                                            ? Colors.grey
                                                                                            : slotsMapdata['chairs'][index]['timings'][subbindex]['isBooked'] != true
                                                                                                ? Colors.green
                                                                                                : primaryColor, // Change color based on time
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Center(
                                                                                          child: Column(
                                                                                            children: [
                                                                                              slotsMapdata['chairs'][index]['timings'][subbindex]['isBooked'] != true
                                                                                                  ? SizedBox()
                                                                                                  : Text(
                                                                                                      "Slot Booked",
                                                                                                      style: GoogleFonts.poppins(
                                                                                                        fontSize: 14,
                                                                                                        color: !isPast ? Colors.white54 : white,
                                                                                                        fontWeight: isPast ? FontWeight.w400 : FontWeight.w600,
                                                                                                      ),
                                                                                                    ),
                                                                                              Text(
                                                                                                "${slotsMapdata['chairs'][index]['timings'][subbindex]['time']}",
                                                                                                style: GoogleFonts.poppins(
                                                                                                  fontSize: 14,
                                                                                                  color: (!isPast || !slotsMapdata['chairs'][index]['isActive']) ? Colors.white54 : white,
                                                                                                  fontWeight: !isPast ? FontWeight.w400 : FontWeight.w600,
                                                                                                ),
                                                                                              ),
                                                                                              slotsMapdata['chairs'][index]['timings'][subbindex]['isBooked'] != true
                                                                                                  ? SizedBox()
                                                                                                  : Text(
                                                                                                      "${slotsMapdata['chairs'][index]['timings'][subbindex]['userName']}",
                                                                                                      style: GoogleFonts.poppins(
                                                                                                        fontSize: 14,
                                                                                                        color: (!isPast || !slotsMapdata['chairs'][index]['isActive']) ? Colors.white54 : white,
                                                                                                        fontWeight: !isPast ? FontWeight.w400 : FontWeight.w600,
                                                                                                      ),
                                                                                                    ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              shrinkWrap: true,
                                                                              itemCount: slotsMapdata['chairs'][index]['timings'].length,
                                                                            ),
                                                                    )
                                                                  ],
                                                                ),
                                                                slotsMapdata['chairs']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'isActive']
                                                                    ? SizedBox()
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          activeSeat(
                                                                              BuildContext: context,
                                                                              slotId: slotsMapdata['chairs'][index]['_id']);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: black.withOpacity(0.3)),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    shrinkWrap: true,
                                                  ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                        : seleedddCat == 1
                            ? MenuScreen(
                                type: "homescreen",
                              )
                            : seleedddCat == 2
                                ? MyGallery(
                                    type: 'homescreen',
                                  )
                                : seleedddCat == 3
                                    ? MyStaff(
                                        type: 'homescreen',
                                      )
                                    : Center(
                                        child: SalonCard(
                                          salonName: "Salon name",
                                          salonNumber: "Salon Mobile number",
                                          salonLocation: "salon Address",
                                        ),
                                      ),
                  )
                ],
              ),
            ),
            body: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  bannersMap.isEmpty
                      ? ShimmerListCAr()
                      :CarouselSlider.builder(
  itemCount: bannersMap['banners'].length,
  itemBuilder: (context, index, realIndex) {
    final banner = bannersMap['banners'][index];
    final imageUrl = resolveImageUrl(banner['image']);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ProgressiveImage(
          placeholder: const AssetImage('assets/images/logo.png'),
          thumbnail: const AssetImage('assets/images/logo.png'),
          image: NetworkImage(imageUrl),
          height: 155,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  },
  options: CarouselOptions(
    height: 155,
    viewportFraction: 0.79,
    autoPlay: true,
    autoPlayInterval: const Duration(seconds: 3),
    autoPlayAnimationDuration: const Duration(milliseconds: 900),
    autoPlayCurve: Curves.easeInOutQuad,
    enableInfiniteScroll: true,
    enlargeCenterPage: true,
    onPageChanged: (index, reason) {
      setState(() {
        currentIndex = index;
      });
    },
  ),
),

                  bannersMap.isEmpty
                      ? SizedBox()
                      : SizedBox(
                          height: 10,
                        ),
                  bannersMap.isEmpty
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: bannersMap['banners'].isEmpty
                              ? SizedBox()
                              : Container(
                                  height: 6,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: List.generate(
                                        bannersMap['banners'].length, (index) {
                                      return AnimatedContainer(
                                        width: currentIndex == index ? 27 : 7,
                                        height: 5,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 3.0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: currentIndex == index
                                              ? secondaryColor
                                              : white.withOpacity(0.3),
                                        ),
                                        duration: Duration(milliseconds: 300),
                                      );
                                    }),
                                  ),
                                ),
                        ),
                ],
              ),
            )),
      ),
    );
  }

  void showCustomOverlay(BuildContext context, String title, String message,
      ContentType contentType) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomOverlay(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 10), () {
      overlayEntry.remove();
    });
  }
}

class SalonCard extends StatelessWidget {
  final String salonName;
  final String salonNumber;
  final String salonLocation;

  const SalonCard({
    required this.salonName,
    required this.salonNumber,
    required this.salonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              salonName,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Icon(Icons.phone, color: Colors.grey[700]),
                SizedBox(width: 8.0),
                Text(
                  salonNumber,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Icon(Icons.location_on, color: Colors.grey[700]),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    salonLocation,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomOverlay extends StatelessWidget {
  final String title;
  final String message;
  final ContentType contentType;

  const CustomOverlay({
    Key? key,
    required this.title,
    required this.message,
    required this.contentType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
            inMaterialBanner:
                true, // Ensure it is not configured for material banner
          ),
        ),
      ),
    );
  }
}
