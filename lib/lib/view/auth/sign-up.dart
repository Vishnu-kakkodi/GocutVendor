import 'dart:convert';
import 'dart:io';

import 'package:bounce/bounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocut_vendor/lib/controllers/maincontroller.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/auth/login-signup.dart';
import 'package:gocut_vendor/lib/view/auth/login.dart';
import 'package:gocut_vendor/lib/view/auth/otp-verification.dart';
import 'package:gocut_vendor/lib/view/auth/searchAddress.dart';
import 'package:gocut_vendor/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/view/mainsection/mainsection.dart';
import 'package:gocut_vendor/lib/view/policies/policy.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:gocut_user/constants/colors.dart';
// import 'package:gocut_user/view/controllers/authController.dart';
// import 'package:gocut_user/view/controllers/mainController.dart';

// import 'package:gocut_user/view/main-section/main-section.dart';
// import 'package:gocut_user/constants/componets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Sign_Up extends StatefulWidget {
  Sign_Up({super.key, required this.mobile});
  String mobile;

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  List<Category> categories = [];
  String? selectedId;
  String? selectedName;

  Future<void> getCategories() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var uri = Uri.parse('$BASE_URL/vendor/getallcategories');

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];

        setState(() {
          categories = data.map((item) => Category.fromJson(item)).toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String genderD = "Select";
  var genderDs = ["Select", "Male", "Female", "Others"];
  String seating = "0";
  var seatingList = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20"
  ];
  TextEditingController salonNa = TextEditingController();
  TextEditingController salonCOnt = TextEditingController();
  TextEditingController salonCat = TextEditingController();
  TextEditingController salonCity = TextEditingController();
  TextEditingController salonAddress = TextEditingController();
  TextEditingController salonAddressPin = TextEditingController();

  TextEditingController fullNam = TextEditingController();
  TextEditingController emailAdd = TextEditingController();
  TextEditingController contactNum = TextEditingController();
  TextEditingController designation = TextEditingController();

  bool _check_box = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCategories();

    getCurrentLocation(context: context);

    salonCOnt = TextEditingController(text: widget.mobile);
  }

  int currentInd = 0;

  File? salonLo;
  File? salonDoc;

  Future<void> _pickSalonLo() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        salonLo = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        salonDoc = File(result.files.single.path!);
      });
    } else {
      print('No PDF selected.');
    }
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:8074245829");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  PageController con = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back,
          color: white,
        ),
        backgroundColor: white,
        surfaceTintColor: white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: InkWell(
          onTap: () async {
            SharedPreferences da = await SharedPreferences.getInstance();

            da.clear();

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LogIn()));

            // Navigator.pushNamedAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(builder: (context) => LogIn_SignUp()),

            //     (context) => false);
          },
          child: TextSemiBold(
            text: "Register Now",
            fontSize: 15,
            textColor: Colors.black,
          ),
        ),
        actions: [
          currentInd == 1
              ? Align(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainSection(),
                        ),
                        (route) => false,
                      );
                      // FlutterPhoneDirectCaller.callNumber('8074245829');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: black.withOpacity(0.2))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Skip',
                              style: TextStyle(
                                color: black,
                                fontFamily: "MonM",
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Align(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                        (route) => false,
                      );
                      // FlutterPhoneDirectCaller.callNumber('8074245829');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(color: black.withOpacity(0.2))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                color: black,
                                fontFamily: "MonM",
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade300,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Bounce(
                      onTap: () {
                        setState(() {
                          currentInd = 0;
                        });
                        con.animateToPage(currentInd,
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeInOutCirc);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: currentInd == 0
                              ? primaryColor
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "Business Details",
                            style: GoogleFonts.poppins(
                              color: currentInd == 0 ? white : black,
                              fontSize: 14,
                              fontWeight: currentInd == 0
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Bounce(
                      onTap: () {
                        // setState(() {
                        //   currentInd = 1;
                        // });
                        con.animateToPage(currentInd,
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeInOutCirc);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: currentInd == 1
                              ? primaryColor
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "Personal Details",
                            style: GoogleFonts.poppins(
                              color: currentInd == 1 ? white : black,
                              fontSize: 14,
                              fontWeight: currentInd == 1
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: con,
                onPageChanged: (index) {
                  setState(() {
                    currentInd = index;
                  });
                },
                children: [bussinessDe(), takePersonalDetail()],
              ),
            )
            // TextMedium(
            //   text: "Register Yourself",
            //   fontSize: 18,
            // ),
          ],
        ),
      ),
    );
  }


Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}


  Widget bussinessDe() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18,
            ),
            TextMedium(
              text: "Store Name",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: salonNa,
              hintName: "Enter Store Name",
              borderColor: black.withOpacity(0.1),
            ),
            SizedBox(
              height: 20,
            ),
            TextMedium(
              text: "Contact Number",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: salonCOnt,
              readOnly: false,
              hintName: "Enter Contact Number",
              type: "number",
              borderColor: black.withOpacity(0.1),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextMedium(
                        text: "Select seating",
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Container(
                          height: 42,
                          decoration: BoxDecoration(
                            border: Border.all(color: black.withOpacity(0.1)),
                            color: white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              padding: EdgeInsets.only(
                                  left: 12, right: 0, top: 0, bottom: 0),
                              isExpanded: true,
                              dropdownColor: white,
                              iconSize: 32,
                              style: TextStyle(color: black, fontSize: 16),
                              value: seating,
                              icon: Icon(
                                Icons.expand_more,
                                color: black,
                                size: 25,
                              ),
                              items: seatingList.map((String? items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items!),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  seating = newValue!;
                                });
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextMedium(
                        text: "Select Category",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      categories.isEmpty
                          ? LinearProgressIndicator()
                          : Container(
                              height: 42,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: black.withOpacity(0.1)),
                                color: white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'Select Category',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    value: selectedId,
                                    items: categories.map((Category category) {
                                      return DropdownMenuItem<String>(
                                        value: category
                                            .id, // Use the category's ID as the value
                                        child: Text(
                                          category.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedId = newValue;
                                        selectedName = categories
                                            .firstWhere((category) =>
                                                category.id == newValue)
                                            .name;
                                      });
                                      print('Selected ID: $selectedId');
                                    },
                                  ),
                                ),
                              ),
                            ),

                      // Container(
                      //   width: double.infinity,
                      //   child: CustomTextField(
                      //     controller: salonCat,
                      //     hintName: "Enter Category",
                      //     borderColor: black.withOpacity(0.1),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Consumer<Maincontroller>(builder: (context, addressData, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextMedium(
                    text: "City",
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: TextEditingController(
                            text: addressData.getVendorCity),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext) {
                            return SearchAddress();
                          }));
                        },
                        readOnly: true,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter City Name",
                            hintStyle: GoogleFonts.poppins(
                                color: black.withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextMedium(
                    text: "Location",
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: TextEditingController(
                            text: addressData.getVendorAddress),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext) {
                            return SearchAddress();
                          }));
                        },
                        readOnly: true,
                        // maxLength: 8,
                        maxLines: null,

                        keyboardType: TextInputType.multiline,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly
                        // ],
                        decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Location",
                            hintStyle: GoogleFonts.poppins(
                                color: black.withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextMedium(
                    text: "Salon Address Pincode",
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: TextEditingController(
                            text: addressData.getVendorPincode),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext) {
                            return SearchAddress();
                          }));
                        },
                        readOnly: true,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Address Pincode",
                            hintStyle: GoogleFonts.poppins(
                                color: black.withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 20),
            TextMedium(
              text: "Address",
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black.withOpacity(0.1))),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  controller: salonAddress,

                  // maxLength: 8,
                  maxLines: null,

                  keyboardType: TextInputType.multiline,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  decoration: InputDecoration(
                      counterText: "",
                      hintText: "Enter Address",
                      hintStyle: GoogleFonts.poppins(
                          color: black.withOpacity(0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                      border: InputBorder.none),
                ),
              ),
            ),
            // CustomTextField(
            //   controller: salonAddressPin,
            //   borderColor: black.withOpacity(0.1),
            //   hintName: "Enter Address Pincode",
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextMedium(
                        text: "Salon Logo",
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Bounce(
                        onTap: () {
                          _pickSalonLo();
                        },
                        child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: salonLo != null
                                  ? Colors.green
                                  : Colors.transparent,
                              border: Border.all(
                                color: salonLo != null
                                    ? Colors.transparent
                                    : black.withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                salonLo != null ? "Logo Uploaded" : "Upload",
                                style: TextStyle(
                                  fontFamily: "IntR",
                                  color: salonLo != null ? white : black,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      )
                      // CustomTextField(
                      //   controller: ageC,
                      //   hintName: "Enter Age",
                      //   borderColor: black.withOpacity(0.1),
                      //   type: "number",
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextMedium(
                        text: "Salon Document",
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Bounce(
                        onTap: () {
                          _pickPDF();
                        },
                        child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: salonDoc != null
                                  ? Colors.green
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: salonDoc != null
                                    ? Colors.transparent
                                    : black.withOpacity(0.2),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                salonDoc != null
                                    ? "Document Uploaded"
                                    : "Upload",
                                style: TextStyle(
                                  fontFamily: "IntR",
                                  color: salonDoc != null ? white : black,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      )
                      // CustomTextField(
                      //   controller: ageC,
                      //   hintName: "Enter Age",
                      //   borderColor: black.withOpacity(0.1),
                      //   type: "number",
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _check_box = !_check_box;
                    });
                  },
                  child: Icon(
                    _check_box
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: black,
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
      Expanded(
  child: RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "By continuing, you agree to our ",
          style: TextStyle(
            fontFamily: "IntR",
            color: black,
            fontSize: 12,
          ),
        ),

        /// TERMS & CONDITIONS
        WidgetSpan(
          child: InkWell(
            onTap: () {
              _launchUrl(
                "https://go-cut-vendor-policies.onrender.com/terms-and-conditions",
              );
            },
            child: Text(
              "Terms & Conditions ",
              style: TextStyle(
                fontFamily: "IntM",
                color: red,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ),
        ),

        TextSpan(
          text: "and ",
          style: TextStyle(
            fontFamily: "IntR",
            color: black,
            fontSize: 12,
          ),
        ),

        /// PRIVACY POLICY
        WidgetSpan(
          child: InkWell(
            onTap: () {
              _launchUrl(
                "https://go-cut-vendor-policies.onrender.com/privacy-and-policy",
              );
            },
            child: Text(
              "Privacy Policy",
              style: TextStyle(
                fontFamily: "IntM",
                color: red,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),

              ],
            ),
            SizedBox(
              height: 40,
            ),
            Consumer<Maincontroller>(builder: (context, addressData, child) {
              return CustomContainer(
                onPressed: () {
                  if (salonNa.text == "" ||
                      selectedId == null ||
                      addressData.getVendorCity == "" ||
                      addressData.getVendorAddress == "" ||
                      addressData.getVendorPincode == "" ||
                      salonAddress.text == "" ||
                      salonLo == null ||
                      seating == "0" ||
                      _check_box == false) {
                    failed(
                        mesg: salonNa.text == ""
                            ? "Please enter salon name"
                            : selectedId == null
                                ? "Please enter salon category"
                                : seating == "0"
                                    ? "Please select salon seating"
                                    : addressData.getVendorCity == ""
                                        ? "Please enter salon city"
                                        : addressData.getVendorAddress == ""
                                            ? "Please enter salon Location"
                                            : addressData.getVendorPincode == ""
                                                ? "Please enter salon address pin"
                                                : salonAddress.text == ""
                                                    ? "Please enter salon address"
                                                    : salonLo == null
                                                        ? "Please select salon logo"
                                                        : "Plese select the terms and conditions",
                        context: context);
                  } else {
                    registerVendorBusin(
                        context,
                        salonNa.text,
                        widget.mobile,
                        seating,
                        salonAddress.text,
                        addressData.getVendorCity,
                        addressData.getVendorLat,
                        addressData.getVendorLog,
                        addressData.getVendorAddress,
                        addressData.getVendorPincode,
                        selectedId!,
                        salonLo,
                        salonDoc, (response) {
                      setState(() {
                        currentInd++;
                      });
                      con.jumpToPage(currentInd);
                    });

                    // Provider.of<AuthController>(context, listen: false)
                    //     .registerUser(
                    //         context: context,
                    //         name: nameC.text,
                    //         email: emailC.text,
                    //         phone: widget.mobile,
                    //         age: ageC.text,
                    //         gender: genderD,
                    //         lat: Provider.of<MainController>(context,
                    //                 listen: false)
                    //             .userLatitudeValue
                    //             .toString(),
                    //         log: Provider.of<MainController>(context,
                    //                 listen: false)
                    //             .userLongitudeValue
                    //             .toString());
                  }
                },
                textName: "Next",
                height: 42,
              );
            }),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget takePersonalDetail() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18,
            ),
            TextMedium(
              text: "Full Name",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: fullNam,
              hintName: "Enter Full Name",
              borderColor: black.withOpacity(0.1),
            ),
            SizedBox(
              height: 20,
            ),
            TextMedium(
              text: "Email",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: emailAdd,
              hintName: "Enter email address",
              borderColor: black.withOpacity(0.1),
            ),
            SizedBox(height: 20),
            TextMedium(
              text: "Contact Number",
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              height: 42,
              child: TextFormField(
                controller: contactNum,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 16,
                    right: 0,
                    bottom: 0,
                  ),
                  hintText: "Enter contact number",
                  hintStyle: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                keyboardType: TextInputType.number,
              ),
            ),
            // CustomTextField(
            //   controller: contactNum,
            //   borderColor: black.withOpacity(0.1),
            //   hintName: "Enter mobile number",
            // ),
            SizedBox(height: 20),
            TextMedium(
              text: "Designation",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: designation,
              borderColor: black.withOpacity(0.1),
              hintName: "Enter your designation",
            ),
            SizedBox(
              height: 140,
            ),
            CustomContainer(
              onPressed: () async {
                SharedPreferences data = await SharedPreferences.getInstance();
                if (fullNam.text.isEmpty) {
                  failed(
                    mesg: "Please enter full name",
                    context: context,
                  );
                  return;
                }

                if (emailAdd.text.isEmpty) {
                  failed(
                    mesg: "Please enter email address",
                    context: context,
                  );
                  return;
                }

                if (!emailAdd.text.contains('@') ||
                    !emailAdd.text.endsWith('.com')) {
                  failed(
                    mesg: "Please enter a valid email address",
                    context: context,
                  );
                  return;
                }

                if (contactNum.text.isEmpty) {
                  failed(
                    mesg: "Please enter contact number",
                    context: context,
                  );
                  return;
                }

                if (contactNum.text.length != 10) {
                  failed(
                    mesg: "Please enter a valid 10-digit contact number",
                    context: context,
                  );
                  return;
                }

                if (designation.text.isEmpty) {
                  failed(
                    mesg: "Please enter your designation",
                    context: context,
                  );
                  return;
                }
                // ignore: use_build_context_synchronously
                registerVendor(
                    context, fullNam.text, emailAdd.text, designation.text,
                    (response) {
                  data.setString('mainToken', accessToken);
                  getStatus();
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MainSection()),
                  //   (route) => false,
                  // );
                });

                // setState(() {
                //   currentInd++;
                // });
                // con.jumpToPage(currentInd);

                // Provider.of<AuthController>(context, listen: false)
                //     .registerUser(
                //         context: context,
                //         name: nameC.text,
                //         email: emailC.text,
                //         phone: widget.mobile,
                //         age: ageC.text,
                //         gender: genderD,
                //         lat: Provider.of<MainController>(context,
                //                 listen: false)
                //             .userLatitudeValue
                //             .toString(),
                //         log: Provider.of<MainController>(context,
                //                 listen: false)
                //             .userLongitudeValue
                //             .toString());
              },
              textName: "Finish",
              height: 42,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future getStatus() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/vendor/auth/isverifiedORregsietered'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      success(mesg: decodedMap['message'], context: context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainSection()),
        (route) => false,
      );

      // /*

      //      decodedMapp['Vendor'][''] == true
      // ? Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MainSection()),
      //     (route) => false,
      //   )
      // : Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Sign_Up(
      //         mobile: widget.mobile,
      //       ),
      //     ),
      //   );
    } else if (response.statusCode == 405) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      failed(mesg: decodedMap['message'], context: context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_Up(
            mobile: widget.mobile,
          ),
        ),
      );
    } else if (response.statusCode == 403) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (context) => false,
      );
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (context) {
      //       return MyAlertDialog();
      //     });
      // var responseString = await response.stream.bytesToString();
      //   final decodedMap = json.decode(responseString);

      //   failed(mesg: decodedMap['message'], context: context);
      //   Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                               builder: (context) => Sign_Up(
      //                                 mobile: widget.mobile,
      //                               ),
      //                             ),
      //                           );
    } else {
      print(response.reasonPhrase);
    }
  }

  termsData() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        color: white,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 4,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: sharp_green_gradeint),
            ),
            Container(
              child: Html(data: '''<u>TERMS AND CONDITIONS</u>\n
      
      <u>1. Agreement Overview:</u>
      
      1.1. These terms and conditions constitute a legal agreement ("Agreement") between You and Hasini Food Catering Services ("Hasini").\n
      1.2. By availing any products or services ("Services") provided by Hasini, you agree to comply with and be bound by these terms and conditions.\n
      1.3. Please read these terms and conditions carefully before utilizing any Services offered by Hasini. Your continued use of the Services implies acceptance of these terms and conditions.\n
      1.4. Hasini reserves the right to amend these terms and conditions at any time by posting an updated version on its website. The updated terms shall be effective immediately upon posting.\n
      
      <u>2. Services Offered:</u>
      
      2.1. Hasini provides food catering services for various events and occasions, including but not limited to weddings, corporate events, parties, and gatherings.\n
      2.2. The scope of services includes menu customization, food preparation, delivery, setup, and cleanup, as per the agreement between Hasini and the client.\n
      2.3. Hasini may offer additional services such as event planning, décor arrangement, and staff provision upon request, subject to availability and additional charges.\n
      
      <u>3. Booking and Payment:</u>
      
      3.1. Clients must book Hasini's services in advance by providing necessary details including event date, venue, estimated guest count, dietary preferences, and any specific requirements.\n
      3.2. A deposit or advance payment may be required to confirm the booking, with the remaining balance due prior to or on the day of the event.\n
      3.3. Payment methods accepted by Hasini include cash, bank transfer, credit/debit cards, or other agreed-upon methods. Payments are non-refundable except as provided in Clause 5.\n
      
      <u>4. Menu Customization and Dietary Restrictions:</u>
      
      4.1. Hasini offers menu customization based on client preferences, dietary restrictions, and cultural/religious considerations.\n
      4.2. Clients must inform Hasini in advance of any dietary restrictions or special requirements, such as allergies, vegetarian/vegan preferences, gluten-free options, etc.\n
      4.3. Hasini will make reasonable efforts to accommodate such requests, but cannot guarantee the absence of allergens or cross-contamination, especially in shared kitchen facilities.\n
      
      <u>5. Cancellation and Refund Policy:</u>
      
      5.1. In the event of cancellation by the client, any deposits or advance payments made to Hasini shall be forfeited, except under exceptional circumstances as determined by Hasini.\n
      5.2. Hasini reserves the right to cancel or reschedule services due to unforeseen circumstances such as natural disasters, emergencies, or force majeure events. In such cases, Hasini will make reasonable efforts to refund any payments made by the client.\n
      
      <u>6. Liability and Indemnity:</u>
      
      6.1. Hasini shall not be liable for any damages, losses, or injuries arising from the consumption of food, beverages, or services provided, except in cases of proven negligence or misconduct by Hasini.\n
      6.2. Clients agree to indemnify and hold Hasini harmless against any claims, liabilities, damages, or expenses arising from their use of Hasini's services, including but not limited to legal fees and costs.\n
      
      <u>7. Governing Law and Dispute Resolution:</u>
      
      7.1. This Agreement shall be governed by and construed in accordance with the laws of [Jurisdiction]. Any disputes arising out of or relating to this Agreement shall be subject to the exclusive jurisdiction of the courts in [Jurisdiction].\n
      
      <u>8. Miscellaneous:</u>
      
      8.1. These terms and conditions constitute the entire agreement between the parties concerning the subject matter herein and supersede all prior agreements and understandings, whether written or oral.\n
      8.2. No waiver of any provision of this Agreement shall be deemed a waiver of any other provision or of Hasini's right to enforce such provision.\n'''),
            )
          ],
        ),
      ),
    );
  }

  privacyData() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        color: white,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 4,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: sharp_green_gradeint),
            ),
            Container(
              child: Html(data: '''<u>Privacy Policy</u>\n
      
      <u>1. Agreement Overview:</u>
      
      1.1. These privacy policy constitute a legal agreement ("Agreement") between You and Hasini Food Catering Services ("Hasini").\n
      1.2. By availing any products or services ("Services") provided by Hasini, you agree to comply with and be bound by these privacy policy.\n
      1.3. Please read these privacy policy carefully before utilizing any Services offered by Hasini. Your continued use of the Services implies acceptance of these privacy policy.\n
      1.4. Hasini reserves the right to amend these privacy policy at any time by posting an updated version on its website. The updated terms shall be effective immediately upon posting.\n
      
      <u>2. Services Offered:</u>
      
      2.1. Hasini provides food catering services for various events and occasions, including but not limited to weddings, corporate events, parties, and gatherings.\n
      2.2. The scope of services includes menu customization, food preparation, delivery, setup, and cleanup, as per the agreement between Hasini and the client.\n
      2.3. Hasini may offer additional services such as event planning, décor arrangement, and staff provision upon request, subject to availability and additional charges.\n
      
      <u>3. Booking and Payment:</u>
      
      3.1. Clients must book Hasini's services in advance by providing necessary details including event date, venue, estimated guest count, dietary preferences, and any specific requirements.\n
      3.2. A deposit or advance payment may be required to confirm the booking, with the remaining balance due prior to or on the day of the event.\n
      3.3. Payment methods accepted by Hasini include cash, bank transfer, credit/debit cards, or other agreed-upon methods. Payments are non-refundable except as provided in Clause 5.\n
      
      <u>4. Menu Customization and Dietary Restrictions:</u>
      
      4.1. Hasini offers menu customization based on client preferences, dietary restrictions, and cultural/religious considerations.\n
      4.2. Clients must inform Hasini in advance of any dietary restrictions or special requirements, such as allergies, vegetarian/vegan preferences, gluten-free options, etc.\n
      4.3. Hasini will make reasonable efforts to accommodate such requests, but cannot guarantee the absence of allergens or cross-contamination, especially in shared kitchen facilities.\n
      
      <u>5. Cancellation and Refund Policy:</u>
      
      5.1. In the event of cancellation by the client, any deposits or advance payments made to Hasini shall be forfeited, except under exceptional circumstances as determined by Hasini.\n
      5.2. Hasini reserves the right to cancel or reschedule services due to unforeseen circumstances such as natural disasters, emergencies, or force majeure events. In such cases, Hasini will make reasonable efforts to refund any payments made by the client.\n
      
      <u>6. Liability and Indemnity:</u>
      
      6.1. Hasini shall not be liable for any damages, losses, or injuries arising from the consumption of food, beverages, or services provided, except in cases of proven negligence or misconduct by Hasini.\n
      6.2. Clients agree to indemnify and hold Hasini harmless against any claims, liabilities, damages, or expenses arising from their use of Hasini's services, including but not limited to legal fees and costs.\n
      
      <u>7. Governing Law and Dispute Resolution:</u>
      
      7.1. This Agreement shall be governed by and construed in accordance with the laws of [Jurisdiction]. Any disputes arising out of or relating to this Agreement shall be subject to the exclusive jurisdiction of the courts in [Jurisdiction].\n
      
      <u>8. Miscellaneous:</u>
      
      8.1. These privacy policy constitute the entire agreement between the parties concerning the subject matter herein and supersede all prior agreements and understandings, whether written or oral.\n
      8.2. No waiver of any provision of this Agreement shall be deemed a waiver of any other provision or of Hasini's right to enforce such provision.\n'''),
            )
          ],
        ),
      ),
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }
}
