import 'dart:async';

import 'package:alert_banner/types/enums.dart';
import 'package:alert_banner/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/color/colors.dart';

import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/bank_de.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Wallet_Screen extends StatefulWidget {
  const Wallet_Screen({super.key});

  @override
  State<Wallet_Screen> createState() => _Wallet_ScreenState();
}

class _Wallet_ScreenState extends State<Wallet_Screen> {
  Timer? time;

  @override
  void initState() {
    salonNa.addListener(_checkLength);
    time = Timer.periodic(Duration(seconds: 1), (val) {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
    get_wallet(context, (response) {
      setState(() {
        wallet_data = response;
      });
      print(wallet_data['walletRequest']);
    });
  }

  @override
  void dispose() {
    salonNa.removeListener(_checkLength);
    salonNa.dispose();
    time?.cancel();
    super.dispose();
  }

  int count = 1;
  GlobalKey dialogKey = GlobalKey();
  TextEditingController amountC = TextEditingController();
  TextEditingController salonNa = TextEditingController();

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    Navigator.pop(context);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    EasyLoading.show();
    await add_wallet(context, amountC.text);
    amountC.clear();
    await get_wallet(context, (response) {
      setState(() {
        wallet_data = response;
      });
    });
    print(response.data.toString());
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    Navigator.pop(context);

    EasyLoading.show();
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

  void _checkLength() {
    if (salonNa.text.length > 5) {
      salonNa.text = salonNa.text.substring(0, 5);
      salonNa.selection = TextSelection.fromPosition(
        TextPosition(offset: salonNa.text.length),
      );
      showAlertBanner(
          // <-- The function!
          context,
          () => print("TAPPED"),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7), color: red),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'You can withdraw only up to 99999 at a time.',
                style: GoogleFonts.poppins(
                    fontSize: 16, color: white, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          alertBannerLocation: AlertBannerLocation.top,
          curveScaleUpAnim: Curves.fastLinearToSlowEaseIn,
          curveScaleDownAnim: Curves.fastLinearToSlowEaseIn,
          curveTranslateAnim: Curves.fastLinearToSlowEaseIn,
          safeAreaLeftEnabled: false,
          safeAreaRightEnabled: false);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('You can withdraw only up to 99999 at a time.'),
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: white,
            toolbarHeight: 75,
            centerTitle: true,
            title: InkWell(
              onTap: () {
                print(wallet_data);
              },
              child: TextSemiBold(
                text: "Wallet",
                fontSize: 18,
                textColor: primaryColor,
              ),
            )),
        body: wallet_data.isEmpty
            ? Center(child: Text("Loading..please wait!"))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: white),
                        child: Row(
                          children: [
                            Container(
                              height: 150,
                              width: 215,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                    "assets/images/wallet_illus.png",
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextBold(
                                    text: "₹${wallet_data['wallet']}",
                                    fontSize: 20,
                                    textColor: primaryColor,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  wallet_data['wallet'] == "0"
                                      ? TextRegular(
                                          text: "No wallet amount available",
                                          fontSize: 13,
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomContainer(
                                          radius: 10,
                                          height: 31,
                                          width: 92,
                                          onPressed: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(40),
                                                            topRight:
                                                                Radius.circular(
                                                                    40))),
                                                context: context,
                                                builder: (BuildContext) {
                                                  return Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: StatefulBuilder(
                                                        key: dialogKey,
                                                        builder: (context,
                                                            StateSetter
                                                                setState) {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                // height: 500,

                                                                width: double
                                                                    .infinity,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                40),
                                                                        topRight:
                                                                            Radius.circular(40))),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            30),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          TextMedium(
                                                                            text:
                                                                                "Add Amount",
                                                                            fontSize:
                                                                                18,
                                                                            // textColor: secondaryColor,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Text(
                                                                        "*Minimum 500 deposite is required to add amount to your wallet",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w400),

                                                                        // textColor: secondaryColor,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          32,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child: CustomTextField(
                                                                          borderColor: black.withOpacity(
                                                                              0.1),
                                                                          radius:
                                                                              10,
                                                                          type:
                                                                              "number",
                                                                          controller:
                                                                              amountC,
                                                                          hintName:
                                                                              "Enter Amount"),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          21,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          45,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        CustomContainer(
                                                                          height:
                                                                              43,
                                                                          width:
                                                                              233,
                                                                          onPressed:
                                                                              () async {
                                                                            if (amountC.text.length <
                                                                                3) {
                                                                              failed(mesg: "Minimum 500 deposite required", context: context);
                                                                            } else {
                                                                              int amt = int.parse(
                                                                                amountC.text,
                                                                              );
                                                                              int valMain = amt * 100;
                                                                              Razorpay razorpay = Razorpay();
                                                                              var options = {
                                                                                'key': 'rzp_test_5lBZXg4ftTpdoH',
                                                                                'amount': valMain,
                                                                                'name': 'GoCut Vendor',
                                                                                'description': 'Food',
                                                                                'retry': {
                                                                                  'enabled': true,
                                                                                  'max_count': 1
                                                                                },
                                                                                'send_sms_hash': true,
                                                                                'prefill': {
                                                                                  'contact': '8888888888',
                                                                                  'email': 'test@razorpay.com'
                                                                                },
                                                                                'external': {
                                                                                  'wallets': [
                                                                                    'paytm'
                                                                                  ]
                                                                                }
                                                                              };
                                                                              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                                                                              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                                                                              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                                                                              razorpay.open(options);
                                                                            }
                                                                          },
                                                                          textName:
                                                                              "Proceed",
                                                                          textSize:
                                                                              15,
                                                                          textColor:
                                                                              white,
                                                                          radius:
                                                                              10,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          30,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  );
                                                });
                                          },
                                          textName: "Add Amount",
                                          textFamily: "IntM",
                                          textSize: 13,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.3))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: salonNa,
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    counterText: "",
                                    hintText: "Enter amount to withdraw",
                                    hintStyle: GoogleFonts.poppins(
                                        color: black.withOpacity(0.4),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                    border: InputBorder.none),
                              ),
                            ),
                          )
                              // CustomTextField(
                              //   controller: salonNa,
                              //   hintName: "Enter amount to withdraw",
                              //   borderColor: black.withOpacity(0.1),
                              // ),
                              ),
                          SizedBox(
                            width: 5,
                          ),
                          CustomContainer(
                            height: 53,
                            width: 90,
                            onPressed: () async {
                              if (wallet_data['vendorBank']['bankdetails'] ==
                                  true) {
                                if (salonNa.text.isEmpty) {
                                  failed(
                                    mesg:
                                        "Please enter the amount you want to withdraw.",
                                    context: context,
                                  );
                                } else {
                                  // Parse the input text as an integer
                                  int amount = int.tryParse(salonNa.text) ?? 0;

                                  if (amount <= 0) {
                                    failed(
                                      mesg:
                                          "Please enter a valid amount you want to withdraw. The amount should be greater than zero.",
                                      context: context,
                                    );
                                  } else {
                                    await with_draw(
                                        context: context, amount: salonNa.text);

                                    get_wallet(context, (response) {
                                      setState(() {
                                        wallet_data = response;
                                        salonNa.clear();
                                      });
                                    });
                                    setState(() {});
                                  }
                                }
                              } else {
                                failed(
                                  mesg: "Please update your bank details first",
                                  context: context,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BankDetails(),
                                  ),
                                );
                              }
                            },
                            textName: "Withdraw",
                            textSize: 15,
                            textColor: white,
                            radius: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextMedium(
                          text: "Details",
                          fontSize: 16,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                      itemCount: wallet_data['walletRequest'].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = wallet_data['walletRequest'][index];

                        DateTime apiDateTime;
                        DateTime now = DateTime.now();
                        String displayDate;

// Define the date formats
                        final DateFormat format12Hour =
                            DateFormat('yyyy-MM-dd hh:mm a');
                        final DateFormat format24Hour =
                            DateFormat('yyyy-MM-dd HH:mm');

// Parse the date and time from the item
                        try {
                          apiDateTime = format12Hour
                              .parse("${item['date']} ${item['time']}");
                        } catch (e) {
                          apiDateTime = format24Hour
                              .parse("${item['date']} ${item['time']}");
                        }

// Calculate the difference in time
                        Duration difference = now.difference(apiDateTime);

// Determine the display date string based on the difference
                        if (difference.inSeconds <= 60) {
                          displayDate = "just now";
                        } else if (difference.inMinutes < 60) {
                          displayDate = "${difference.inMinutes} minutes ago";
                        } else if (difference.inHours < 24) {
                          displayDate = "${difference.inHours} hours ago";
                        } else if (difference.inDays == 1) {
                          displayDate = "1 day ago";
                        } else if (difference.inDays == 2) {
                          displayDate = "2 days ago";
                        } else if (difference.inDays == 3) {
                          displayDate = "3 days ago";
                        } else {
                          // Define the output date format
                          final DateFormat outputFormat =
                              DateFormat('MMM dd, yyyy\nhh:mm a');
                          displayDate = outputFormat.format(apiDateTime);
                        }
                        return Column(
                          children: [
                            InkWell(
                              // onTap: () {
                              //   generateAndShowPdf(context, item);
                              // },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 5, right: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 55,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 36,
                                            width: 36,
                                            decoration: BoxDecoration(
                                              color: item['status'] ==
                                                      "Completed"
                                                  ? Colors.green
                                                  : item['status'] == "Rejected"
                                                      ? Colors.red
                                                      : white,
                                              border: Border.all(
                                                  color:
                                                      black.withOpacity(0.1)),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: item['status'] == "Completed"
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: white,
                                                  )
                                                : item['status'] == "Rejected"
                                                    ? Icon(
                                                        Icons.cancel,
                                                        color: white,
                                                      )
                                                    : item['status'] ==
                                                            "In Process"
                                                        ? LoadingAnimationWidget
                                                            .halfTriangleDot(
                                                            color: primaryColor,
                                                            size: 18,
                                                          )
                                                        : item['status'] ==
                                                                "Credited"
                                                            ? Icon(
                                                                Icons
                                                                    .south_west,
                                                                size: 25,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : item['status'] ==
                                                                    "Debited"
                                                                ? Icon(
                                                                    Icons
                                                                        .north_east,
                                                                    size: 25,
                                                                    color: Colors
                                                                        .blue,
                                                                  )
                                                                : LoadingAnimationWidget
                                                                    .halfTriangleDot(
                                                                    color:
                                                                        primaryColor,
                                                                    size: 18,
                                                                  ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextRegular(
                                            text: "$displayDate",
                                            fontSize: 8,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextMedium(
                                          text: item['description'],
                                          // item['type'] == "Credited"
                                          //     ? "Paid To"
                                          //     : "Received from",
                                          fontSize: 14,
                                        ),

                                        SizedBox(
                                          height: 5,
                                        ),

                                        Builder(builder: (context) {
                                          return TextRegular(
                                            text:
                                                "referal id : #12${index + 4}${index + 9}${index + 10}${index + 420}",
                                            fontSize: 11,
                                            textColor:
                                                primaryColor.withOpacity(0.6),
                                          );
                                        }),

                                        // SizedBox(
                                        //   height: 15,
                                        // )
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        TextMedium(
                                          text: "₹${item['amount']}",
                                          fontSize: 17,
                                        ),

                                        // SizedBox(
                                        //   height: 5,
                                        // ),

                                        // TextRegular(
                                        //   text: item['time'],
                                        //   fontSize: 11,
                                        //   textColor: black.withOpacity(0.9),
                                        // ),

                                        // Text(
                                        //   "₹30",
                                        //   style: TextStyle(
                                        //       fontFamily: "IntM",
                                        //       fontSize: 14,
                                        //       color: black),
                                        // ),
                                        // Text(
                                        //   index % 2 == 0 ? "Debited" : "Credited",
                                        //   style: TextStyle(
                                        //       fontFamily: "IntR",
                                        //       fontSize: 11,
                                        //       color: black),
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: black.withOpacity(0.1),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ));
  }

  void generateAndShowPdf(
      BuildContext context, Map<String, dynamic> item) async {
    final pdf = pw.Document();

    final logo = await networkImage(
        'https://images.pexels.com/photos/20354191/pexels-photo-20354191/free-photo-of-head-of-turtle-in-sea.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'); // Replace with your logo URL

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1, color: PdfColors.black),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(width: 1, color: PdfColors.black),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(logo, width: 50, height: 50),
                      pw.Text('Your Company Name',
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Wallet Recharge',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 20),
                      pw.Text('Type: ${item['type']}',
                          style: pw.TextStyle(fontSize: 18)),
                      pw.Text('Amount: ₹${item['amount']}',
                          style: pw.TextStyle(fontSize: 18)),
                      pw.Text('Date: ${item['date']}',
                          style: pw.TextStyle(fontSize: 18)),
                      pw.Text('Time: ${item['time']}',
                          style: pw.TextStyle(fontSize: 18)),
                      pw.Text('Referal ID: #123456',
                          style: pw.TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(width: 1, color: PdfColors.black),
                    ),
                  ),
                  child: pw.Center(
                    child: pw.Text('Thank you for using our service',
                        style: pw.TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
