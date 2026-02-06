import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bounce/bounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/mainsection/booking/bookings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddCombo extends StatefulWidget {
  AddCombo({super.key});

  @override
  State<AddCombo> createState() => _AddComboState();
}

class _AddComboState extends State<AddCombo> {
  TextEditingController searchCon = TextEditingController();
  String genderD = "Select";
  var genderDs = ["Select", "Male", "Female", "Others"];

  String seating = "Premium";
  var seatingList = ["Premium", 'Ordinary'];
  // String seating = "0";
  // var seatingList = [
  //   "0",
  //   "1",
  //   "2",
  //   "3",
  //   "4",
  //   "5",
  //   "6",
  //   "7",
  //   "8",
  //   "9",
  //   "10",
  //   "11",
  //   "12",
  //   "13",
  //   "14",
  //   "15",
  //   "16",
  //   "17",
  //   "18",
  //   "19",
  //   "20"
  // ];
  TextEditingController salonNa = TextEditingController();
  TextEditingController salonCOnt = TextEditingController();
  TextEditingController salonDesc = TextEditingController();
  TextEditingController salonCat = TextEditingController();
  TextEditingController salonCatss = TextEditingController();
  TextEditingController salonCity = TextEditingController();
  TextEditingController salonAddress = TextEditingController();

  TextEditingController fullNam = TextEditingController();
  TextEditingController emailAdd = TextEditingController();
  TextEditingController contactNum = TextEditingController();
  TextEditingController designation = TextEditingController();

  bool _check_box = false;

  Timer? ti;

  @override
  void initState() {
    EasyLoading.dismiss();
    ti = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
    ofSelectIt.clear();
    ofSelectItNames.clear();
  }

  @override
  void dispose() {
    ti?.cancel();
    super.dispose();
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

  PageController con = PageController();

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDateEn = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectDateEn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateEn,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateEn)
      setState(() {
        _selectedDateEn = picked;
      });
  }

  Future addCombosss() async {
    EasyLoading.show();
    // var stringList = ofSelectIt.map((item) => item.toString()).toList();
    // print(stringList);

    var serviceIdsJson = jsonEncode(ofSelectIt);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('$BASE_URL/vendor/combo/addcombo'));
    // Prepare the request body
    request.fields.addAll({
      "serviceId":
          serviceIdsJson, // Directly pass the list without converting to string
      "categoryName": "",
      // seating.toString(),
      "comboName": salonNa.text,
      "description": salonDesc.text,
      'startDate': "${_selectedDate.toLocal()}".split(' ')[0],
      'endDate': "${_selectedDateEn.toLocal()}".split(' ')[0],
      'serviceValue': salonCat.text.toString(),
      'comboPrice': salonCatss.text,
    });
    salonLo == null
        ? null
        : request.files
            .add(await http.MultipartFile.fromPath('image', salonLo!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      await get_combos(context, (response) {
        setState(() {
          combos_list = response['vendorcombos'];
          ofSelectIt.clear();
          ofSelectItNames.clear();
        });
      });
      Navigator.pop(context);
    } else {
      print(ofSelectIt.toString());
      EasyLoading.dismiss();
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
        title: Text(
          "Add Combo",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: bussinessDe()),
    );
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
              text: "Combo Name",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: salonNa,
              hintName: "Enter Combo Name",
              borderColor: black.withOpacity(0.1),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextMedium(
                    text: "Service",
                  ),
                ),
                Bounce(
                  onTap: () {
                    showDialog(
                        context: context, builder: (context) => GetServices());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ADD",
                        style: GoogleFonts.poppins(color: white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                    )),
                child: ofSelectItNames.isEmpty
                    ? Center(child: Text("Please select service"))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 2.0),
                            child: InkWell(
                              onTap: () {
                                ofSelectIt.removeAt(index);
                                ofSelectItNames.removeAt(index);
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        ofSelectItNames[index],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: ofSelectItNames.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                      )),
            // CustomTextField(
            //   controller: salonCOnt,
            //   // readOnly: true,
            //   hintName: "Service name",
            //   borderColor: black.withOpacity(0.1),
            // ),
            SizedBox(
              height: 20,
            ),
            TextMedium(
              text: "Description",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: salonDesc,
              // readOnly: true,
              hintName: "Enter Description",
              borderColor: black.withOpacity(0.1),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Bounce(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextMedium(
                          text: "Start Date",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF9F9F9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("${_selectedDate.toLocal()}"
                                        .split(' ')[0]),
                                  ),
                                  Icon(Icons.calendar_month),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Bounce(
                    onTap: () {
                      _selectDateEn(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextMedium(
                          text: "End Date",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF9F9F9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("${_selectedDateEn.toLocal()}"
                                        .split(' ')[0]),
                                  ),
                                  Icon(Icons.calendar_month),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
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
                        text: "Service Value",
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Container(
                        width: double.infinity,
                        child: CustomTextField(
                          type: 'number',
                          controller: salonCat,
                          hintName: "Enter Service Value",
                          borderColor: black.withOpacity(0.1),
                        ),
                      ),
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
                        text: "Combo Value",
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Container(
                        width: double.infinity,
                        child: CustomTextField(
                          type: 'number',
                          controller: salonCatss,
                          hintName: "Enter Combo Value",
                          borderColor: black.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            TextMedium(
              text: "Add Combo Image",
            ),
            SizedBox(
              height: 14,
            ),
            Bounce(
              onTap: () {
                _pickSalonLo();
              },
              child: Container(
                  height: 155,
                  width: 155,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    border: Border.all(
                      color: black.withOpacity(0.2),
                    ),
                  ),
                  child: salonLo == null
                      ? Center(
                          child: TextMedium(
                          text: "Select",
                          textColor: black.withOpacity(0.2),
                        ))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Image.file(salonLo!),
                          ),
                        )),
            ),
            // SizedBox(height: 20),
            // TextMedium(
            //   text: "Category",
            // ),
            // SizedBox(
            //   height: 14,
            // ),
            // Container(
            //     height: 42,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: black.withOpacity(0.1)),
            //       color: white.withOpacity(0.7),
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: DropdownButtonHideUnderline(
            //       child: DropdownButton(
            //         padding:
            //             EdgeInsets.only(left: 12, right: 0, top: 0, bottom: 0),
            //         isExpanded: true,
            //         dropdownColor: white,
            //         iconSize: 32,
            //         style: TextStyle(color: black, fontSize: 16),
            //         value: seating,
            //         icon: Icon(
            //           Icons.expand_more,
            //           color: black,
            //           size: 25,
            //         ),
            //         items: seatingList.map((String? items) {
            //           return DropdownMenuItem(
            //             value: items,
            //             child: Text(items!),
            //           );
            //         }).toList(),
            //         onChanged: (String? newValue) {
            //           setState(() {
            //             seating = newValue!;
            //           });
            //         },
            //       ),
            //     )),
            SizedBox(
              height: 40,
            ),
            CustomContainer(
              onPressed: () {
                addCombosss();
              },
              textName: "Add",
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
            CustomTextField(
              controller: contactNum,
              borderColor: black.withOpacity(0.1),
              hintName: "Enter mobile number",
            ),
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
              hintName: "Enter your desgnation",
            ),
            SizedBox(
              height: 140,
            ),
            CustomContainer(
              onPressed: () async {
                // SharedPreferences data = await SharedPreferences.getInstance();
                // if (fullNam.text == "" ||
                //     emailAdd.text == "" ||
                //     contactNum.text == "" ||
                //     designation.text == "") {
                //   // ignore: use_build_context_synchronously
                //   failed(
                //       mesg: fullNam.text == ""
                //           ? "Please enter full name"
                //           : emailAdd.text == ""
                //               ? "Please enter email address"
                //               : contactNum.text == ""
                //                   ? "Please enter contact number"
                //                   : designation.text == ""
                //                       ? "Please enter your designation"
                //                       : "",
                //       context: context);
                // } else {
                //   // ignore: use_build_context_synchronously
                //   registerVendor(
                //       context, fullNam.text, emailAdd.text, designation.text,
                //       (response) {
                //     data.setString('mainToken', accessToken);
                //     Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(builder: (context) => MainSection()),
                //       (route) => false,
                //     );
                //   });

                //   // setState(() {
                //   //   currentInd++;
                //   // });
                //   // con.jumpToPage(currentInd);

                //   // Provider.of<AuthController>(context, listen: false)
                //   //     .registerUser(
                //   //         context: context,
                //   //         name: nameC.text,
                //   //         email: emailC.text,
                //   //         phone: widget.mobile,
                //   //         age: ageC.text,
                //   //         gender: genderD,
                //   //         lat: Provider.of<MainController>(context,
                //   //                 listen: false)
                //   //             .userLatitudeValue
                //   //             .toString(),
                //   //         log: Provider.of<MainController>(context,
                //   //                 listen: false)
                //   //             .userLongitudeValue
                //   //             .toString());
                // }
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
}

List ofSelectIt = [];
List ofSelectItNames = [];

class GetServices extends StatefulWidget {
  const GetServices({super.key});

  @override
  State<GetServices> createState() => _GetServicesState();
}

class _GetServicesState extends State<GetServices> {
  Timer? timer;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredServices {
    List<dynamic> services = addedServicesMap['services'] ?? [];
    List<Map<String, dynamic>> castedServices =
        services.cast<Map<String, dynamic>>();

    if (_searchQuery.isEmpty) {
      return castedServices;
    }
    return castedServices
        .where((service) => (service['name'] ?? service['serviceName'])
            .toLowerCase()
            .contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black.withOpacity(0.2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 1.1),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: white,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Add Combos",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF9F9F9),
                      ),
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 18,
                          ),
                          hintText: "Search",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  addedServicesMap.isEmpty
                      ? ShimmerList()
                      : _filteredServices.isEmpty
                          ? Center(
                              child: Text("No services were added previously"))
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, top: 8.0),
                                  child: Bounce(
                                    onTap: () {
                                      if (!ofSelectIt.contains(
                                          _filteredServices[index]['_id'])) {
                                        ofSelectIt.add(
                                            _filteredServices[index]['_id']);
                                        ofSelectItNames.add(
                                            _filteredServices[index]['name'] ??
                                                _filteredServices[index]
                                                    ['serviceName']);
                                      } else {
                                        ofSelectIt.remove(
                                            _filteredServices[index]['_id']);
                                        ofSelectItNames.remove(
                                            _filteredServices[index]['name'] ??
                                                _filteredServices[index]
                                                    ['serviceName']);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          ofSelectIt.contains(
                                                  _filteredServices[index]
                                                      ['_id'])
                                              ? BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 2.0,
                                                )
                                              : BoxShadow(
                                                  color: Colors.transparent
                                                      .withOpacity(0.3),
                                                  blurRadius: 2.0,
                                                ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: white,
                                                  border: Border.all(
                                                    color: black,
                                                  ),
                                                ),
                                                child: ofSelectIt.contains(
                                                        _filteredServices[index]
                                                            ['_id'])
                                                    ? Icon(
                                                        Icons.done,
                                                        size: 17,
                                                      )
                                                    : null),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                _filteredServices[index]
                                                        ['name'] ??
                                                    _filteredServices[index]
                                                        ['serviceName'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "₹ ${_filteredServices[index]['offerPrice'].toString()}",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: black,
                                                  ),
                                                ),
                                              ),
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
                              itemCount: _filteredServices.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Bounce(
                      onTap: () {
                        Navigator.pop(context);
                        // if (code == "" || code.length < 4) {
                        //   failed(
                        //       mesg: "Please enter service OTP first",
                        //       context: context);
                        // } else {
                        //   Navigator.pop(context);
                        //   showDialog(
                        //       barrierDismissible: false,
                        //       context: context,
                        //       builder: (context) {
                        //         return EndService().animate().scale().shimmer();
                        //       });
                        // }

                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => MakeARequest()));
                        // Navigator.of(context).push(
                        //   FadeRouteBuilder(
                        //     page: const MakeARequest(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // color: primaryColor,
                          gradient: sharp_green_gradeint,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(-1, 0),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Add combo",
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
