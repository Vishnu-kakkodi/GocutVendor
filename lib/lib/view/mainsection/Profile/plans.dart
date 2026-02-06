import 'dart:convert';
import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:bounce/bounce.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/profile_de.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/support_scr.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/planhistory.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool _isSubscribed = false;
  String _mobileNumbileProfile = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlanHist();
    get_salon(context, (response) {
      setState(() {
        salon = response['salonprofile'];
        print("the salon data: ${salon}");
        if (salon.isNotEmpty) {
          _mobileNumbileProfile = salon['mobileNumber'];
        }
      });
    });
    get_plans(context, (response) {
      setState(() {
        _isSubscribed = response['isSubscribed'];
        all_plans = response['data'];
        print("djfdfkdfdkfkdfkfkkdkf${_isSubscribed}");
      });
      print(response);
    });
  }

  String idddd = "";

  Future addPlanorBuyOne(transID) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/vendorsubscribe/addsubscribe'));
    request.bodyFields = {
      'planId': '$idddd',
      'transactionId': '$transID',
      'transactionStatus': 'completed'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      // success(mesg: decodedMap['message'], context: context);
      // success(mesg: "Bought plan applied", context: context);

      EasyLoading.dismiss();

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
              padding: MediaQuery.of(context).viewInsets,
              child: SuccessDialog());
        },
      );

      getPlanHist();
      get_plans(context, (response) {
        setState(() {
          _isSubscribed = response['isSubscribed'];
          all_plans = response['data'];
          print("djfdfkdfdkfkdfkfkkdkf${_isSubscribed}");
        });
        print(response);
      });

      print(decodedMap['subscribe']['_id']);

      generatePdf(context, decodedMap);
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
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
            padding: MediaQuery.of(context).viewInsets,
            child: CancelledPalns());
      },
    );
    // Navigator.pop(context);
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    EasyLoading.show();
    * */
    // EasyLoading.show();
    // toastification.show(
    //   type: ToastificationType.error,
    //   style: ToastificationStyle.flatColored,
    //   context: context,
    //   title: Text("Payment Failure,\nTry again after some time."),
    //   autoCloseDuration: const Duration(seconds: 5),
    // );
    // showAlertDialog(context, "Payment Failed",
    //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    EasyLoading.show();
    print(response.data.toString());
    addPlanorBuyOne(response.paymentId.toString());

    // successProcewes(response.paymentId.toString(), "online");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    Navigator.pop(context);
    // toastification.show(
    //   type: ToastificationType.error,
    //   style: ToastificationStyle.flatColored,
    //   context: context,
    //   title: Text(response.walletName.toString()),
    //   autoCloseDuration: const Duration(seconds: 5),
    // );
    EasyLoading.show();
    // showAlertDialog(
    //     context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
      print("get all plans here${decodedMap}");
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
        elevation: 4,
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Plans",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlansHistory(),
                ),
              );
            },
            icon: Icon(Icons.history_outlined),
          )
        ],
      ),
      body: _mobileNumbileProfile == "7995630479"
          ? Center(child: Text("comming soon"))
          : SingleChildScrollView(
              child: Column(
                children: [
                  planHis.isEmpty
                      ? SizedBox()
                      : planHis['subscribeResult'].isEmpty
                          ? Text(
                              "You have not subscribed to any of our plans yet\nDo Subscribe!")
                          : Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Transform.scale(
                                      scale: 1.5,
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: Image.asset(
                                          'assets/images/crown.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "You are currently under",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.4),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    planHis['subscribeResult'][0]['planName'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Benefits",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  planHis.isEmpty
                                      ? SizedBox()
                                      : ListView.builder(
                                          itemCount: planHis['subscribeResult']
                                                  [0]['benfits']
                                              .length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Icon(
                                                      Icons.done,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      planHis['subscribeResult']
                                                          [0]['benfits'][index],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                  Divider(),
                  SizedBox(height: 10),
                  if (all_plans.isEmpty)
                    Center(child: Text("No Plans"))
                  else
                    ListView.builder(
                      itemBuilder: (context, index) {
                        final item = all_plans[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 9.0),
                          child: Bounce(
                            onTap: () {
                              // print(planHis['subscribeResult'][0]['planId']);
                              // print(item['planId']);
                              if (planHis['subscribeResult'].isEmpty) {
                                setState(() {
                                  idddd = item['_id'];
                                });
                                int amt = int.parse(
                                  item['offerprice'],
                                );
                                int valMain = amt * 100;
                                Razorpay razorpay = Razorpay();
                                var options = {
                                  'key': 'rzp_test_5lBZXg4ftTpdoH',
                                  'amount': valMain,
                                  'name': 'GoCut Vendor',
                                  'description': 'Barbers',
                                  'retry': {'enabled': true, 'max_count': 1},
                                  'send_sms_hash': true,
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  },
                                  'external': {
                                    'wallets': ['paytm']
                                  }
                                };
                                razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                    handlePaymentErrorResponse);
                                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                    handlePaymentSuccessResponse);
                                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                    handleExternalWalletSelected);
                                razorpay.open(options);
                              } else if (item['_id'] !=
                                      planHis['subscribeResult'][0]['planId'] &&
                                  _isSubscribed) {
                                setState(() {
                                  idddd = item['_id'];
                                });
                                int amt = int.parse(
                                  item['offerprice'],
                                );
                                int valMain = amt * 100;
                                Razorpay razorpay = Razorpay();
                                var options = {
                                  'key': 'rzp_test_5lBZXg4ftTpdoH',
                                  'amount': valMain,
                                  'name': 'GoCut Vendor',
                                  'description': 'Barbers',
                                  'retry': {'enabled': true, 'max_count': 1},
                                  'send_sms_hash': true,
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  },
                                  'external': {
                                    'wallets': ['paytm']
                                  }
                                };
                                razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                    handlePaymentErrorResponse);
                                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                    handlePaymentSuccessResponse);
                                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                    handleExternalWalletSelected);
                                razorpay.open(options);
                              } else {
                                setState(() {
                                  idddd = item['_id'];
                                });
                                int amt = int.parse(
                                  item['offerprice'],
                                );
                                int valMain = amt * 100;
                                Razorpay razorpay = Razorpay();
                                var options = {
                                  'key': 'rzp_test_5lBZXg4ftTpdoH',
                                  'amount': valMain,
                                  'name': 'GoCut Vendor',
                                  'description': 'Barbers',
                                  'retry': {'enabled': true, 'max_count': 1},
                                  'send_sms_hash': true,
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': 'test@razorpay.com'
                                  },
                                  'external': {
                                    'wallets': ['paytm']
                                  }
                                };
                                razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                    handlePaymentErrorResponse);
                                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                    handlePaymentSuccessResponse);
                                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                    handleExternalWalletSelected);
                                razorpay.open(options);
                              }
                            },
                            child: Container(
                              // height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                color: primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 25),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Image.network(
                                              IMAGE_BASE_URL + item['image']),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "${item['name']}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "₹ ${item['price']}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Buy Now",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${item['description']}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: white.withOpacity(0.4),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Validity",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: white.withOpacity(0.4),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "${item['validity']} Months",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Discount",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: white.withOpacity(0.4),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "${item['offerprice']}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Benifits",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: white.withOpacity(0.4),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: item['benfits'].length,
                                              itemBuilder:
                                                  (context, subbindex) {
                                                return Text(
                                                  " - ${item['benfits'][subbindex]}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: white,
                                                  ),
                                                );
                                              })
                                          // SizedBox(
                                          //   width: 100,
                                          // child: Text(
                                          //   "${item['benfits'][0]}",
                                          //   style: GoogleFonts.poppins(
                                          //     fontSize: 13,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: white,
                                          //   ),
                                          // ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: all_plans.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    )
                ],
              ),
            ),
    );
  }

  //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::://
  //::::::::::::::::::::::::GENERATE PDF:::::::::::::::::::::::::::::::::::::://
  //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::://

  Future uploadPDFIN(iddd, File? pdfff) async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.MultipartRequest('PUT',
        Uri.parse('$BASE_URL/vendor/vendorsubscribe/updateinvoice/$iddd'));
    request.files.add(
        await http.MultipartFile.fromPath('subscribeInvoice', pdfff!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);
      EasyLoading.dismiss();
      get_plans(context, (response) {
        setState(() {
          all_plans = response['data'];
        });
        print(response);
      });
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
      EasyLoading.dismiss();
    }
  }

  void generatePdf(
    BuildContext context,
    Map indexDetails,
  ) async {
    EasyLoading.show();
    final pdf = pw.Document();

    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    final logoImages = pw.MemoryImage(
      (await rootBundle.load('assets/images/crown.png')).buffer.asUint8List(),
    );

    // Parse the input dates
    DateTime startDate =
        DateTime.parse(indexDetails['subscribe']['startDate']!);
    DateTime endDate = DateTime.parse(indexDetails['subscribe']['endDate']!);

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
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Subscription Plan',
                          style: pw.TextStyle(
                            fontSize: 25,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Image(logoImages, width: 40, height: 40),
                      ]),
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
                          "# " + indexDetails['payment']['transactionId']!,
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
                          indexDetails['subscribe']['planName']!,
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
                  bottom: 90,
                  right: 20,
                  child: pw.Text(
                    'Payable to:',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Positioned(
                  bottom: 60,
                  right: 20,
                  child: pw.Text(
                    'GoCut House Gachibowli, Hyderabad, 500032.',
                    style: pw.TextStyle(
                        fontSize: 12, color: PdfColors.blueGrey700),
                  ),
                ),
                // pw.Positioned(
                //   bottom: 110,
                //   left: 20,
                //   child: pw.Text(
                //     '${salon['name']}\n${salon['address']}',
                //     style: pw.TextStyle(
                //         fontSize: 12, color: PdfColors.blueGrey700),
                //   ),
                // ),
                // pw.Positioned(
                //   bottom: 130,
                //   right: 20,
                //   child: pw.Text(
                //     'Payable to:',
                //     style: pw.TextStyle(
                //         fontSize: 12, fontWeight: pw.FontWeight.bold),
                //   ),
                // ),
                // pw.Positioned(
                //   bottom: 110,
                //   right: 20,
                //   child: pw.Text(
                //     'GoCut House\nGachibowli, Hyderabad, 500032.',
                //     style: pw.TextStyle(
                //         fontSize: 12, color: PdfColors.blueGrey700),
                //   ),
                // ),
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
    final file = File("${output.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    await uploadPDFIN(indexDetails['subscribe']['_id'], file);

    // // Open the PDF file
    // await OpenFile.open(file.path);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('PDF Saved at ${file.path}')),
    // );
  }
  //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::://
  //::::::::::::::::::::::::GENERATE PDF:::::::::::::::::::::::::::::::::::::://
  //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::://
}

class CancelledPalns extends StatefulWidget {
  const CancelledPalns({super.key});

  @override
  State<CancelledPalns> createState() => _CancelledPalnsState();
}

class _CancelledPalnsState extends State<CancelledPalns> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  noOfBubbles: 4,
                  colorsOfBubbles: [
                    Colors.red,
                  ],
                  sizeFactor: 0.16,
                  duration: 420, // 120 seconds.
                  opacity: 70,
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
                      child: Text("Payment Cancelled",
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
                        "We noticed that your payment was canceled. If you encountered any issues or have any concerns, please let us know so we can assist you promptly.",
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SupportScreen(),
                                ),
                              );
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
                                      child: Text("Raise a Ticket",
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
                            onTap: () {
                              Navigator.pop(context);
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
                                    child: Text("Change Plan",
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

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key});

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 280),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: white,
        ),
        child: Stack(
          children: [
            Transform.scale(
                scale: 4,
                child: Center(
                    child: Lottie.asset('assets/animations/congr.json'))),
            // Image.asset('assets/animations/congr.gif'),
            BlurryContainer(
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
                      noOfBubbles: 4,
                      colorsOfBubbles: [
                        Colors.green.withOpacity(0.5),
                      ],
                      sizeFactor: 0.16,
                      duration: 620, // 120 seconds.
                      opacity: 70,
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
                          child: Text("Payment Success",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            "We are pleased to inform you that your payment was successfully processed, and your plan will be activated immediately. If you have any questions or need further assistance, please feel free to reach out.",
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SupportScreen(),
                                    ),
                                  );
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
                                          child: Text("Raise a Ticket",
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
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlansHistory(),
                                    ),
                                  );
                                  // Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: green.withOpacity(0.2),
                                      width: 2,
                                    ),
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                  child: BlurryContainer(
                                      blur: 2,
                                      height: 50,
                                      shadowColor: Colors.black38,
                                      borderRadius: BorderRadius.circular(90),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text("View History",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }
}
