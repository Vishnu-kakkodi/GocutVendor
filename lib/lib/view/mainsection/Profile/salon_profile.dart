import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gocut_vendor/global/data.dart';
import 'package:gocut_vendor/lib/controllers/maincontroller.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/auth/searchAddress.dart';
import 'package:gocut_vendor/lib/view/auth/sign-up.dart';
import 'package:http/http.dart' as http;
import 'package:bounce/bounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SalonProfile extends StatefulWidget {
  const SalonProfile({super.key});

  @override
  State<SalonProfile> createState() => _SalonProfileState();
}

class _SalonProfileState extends State<SalonProfile> {
  String salonCatName = "";
  String salonCatID = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getCategories();

      await Provider.of<Maincontroller>(context, listen: false)
          .toggleVendorAddress(
              salon['address'],
              salon['pincode'],
              salon['city'],
              salon['maplocation']['coordinates'][0],
              salon['maplocation']['coordinates'][1]);
      await get_salon(context, (response) {
        setState(() {
          salon = response['salonprofile'];
          print("the salon dat : ${salon}");
          if (salon.isNotEmpty) {
            salonNa = TextEditingController(text: salon['name']);
            salonCOnt = TextEditingController(text: salon['mobileNumber']);
            salonCat = TextEditingController(text: salon['mobileNumber']);
            salonCity = TextEditingController(text: salon['city']);
            salonAboutUS = TextEditingController(text: salon['description']);
            salonLocation = TextEditingController(text: salon['address']);
            salonAddress = TextEditingController(text: salon['street']);
            salonCatName = salon['categoryName'];
            salonCatID = salon['categoryId'] ?? "";
            seating = salon['seats'].toString();
          }
          print(salon['seats'].toString());
        });
        // print("the salon dat : ${salon}");
      });
    });
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
  TextEditingController salonLocation = TextEditingController();
  TextEditingController salonAboutUS = TextEditingController();
  TextEditingController salonAddress = TextEditingController();

  File? salonLo;
  // File? salonDoc;
  List<File> salonDocs = []; // Declare the list to store selected PDF files
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

  // Future<void> _pickPDF() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //     allowMultiple: true
  //   );
  //   if (result != null) {
  //     setState(() {
  //       salonDoc = File(result.files.single.path!);
  //     });
  //   } else {
  //     print('No PDF selected.');
  //   }
  // }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true, // Allow multiple files to be selected
    );

    if (result != null) {
      setState(() {
        salonDocs = result.paths.map((path) => File(path!)).toList();
      });
    } else {
      print('No PDF selected.');
    }
  }

// update

  update() async {
    final addressData = Provider.of<Maincontroller>(context, listen: false);

    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.MultipartRequest(
        'PUT', Uri.parse('$BASE_URL/vendor/auth/updatestore'));

    request.fields.addAll({
      'name': salonNa.text,
      'mobileNumber': salonCOnt.text,
      'email': "",
      'seats': seating,
      'city': addressData.getVendorCity,
      'pincode': addressData.getVendorPincode,
      'street': salonAddress.text,
      'address': addressData.getVendorAddress,
      'banks': 'sbi',
      'longitude': addressData.getVendorLog.toString(),
      'latitude': addressData.getVendorLat.toString(),
      'description': salonAboutUS.text,
      'categoryId': salonCatID!
    });

    if (salonLo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('logo', salonLo!.path));
    }

    // Add each document in the salonDocs list with the same field name 'documents'
    for (int i = 0; i < salonDocs.length; i++) {
      request.files.add(
          await http.MultipartFile.fromPath('documents', salonDocs[i].path));
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      get_salon(context, (response) {
        setState(() {
          salon = response['salonprofile'];
          print("the salon data: ${salon}");
          if (salon.isNotEmpty) {
            salonNa = TextEditingController(text: salon['name']);
            salonCOnt = TextEditingController(text: salon['mobileNumber']);
            salonCat = TextEditingController(text: salon['mobileNumber']);
            salonCity = TextEditingController(text: salon['city']);
            salonLocation = TextEditingController(text: salon['address']);
          }
        });
      });
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      Navigator.pop(context);
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      failed(mesg: decodedMap['message'], context: context);
    }
  }

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
          // Set the selectedId based on the categoryName from salon
          Category? initialCategory = categories.firstWhere(
              (category) => category.name == salon['categoryName'],
              orElse: () => categories[0]);
          if (initialCategory != null) {
            selectedId = salon['categoryId'];
            selectedName = initialCategory.name;
          }
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Bounce(
          onTap: () {
            print(accessToken);
          },
          child: Text(
            "Salon Profile",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: bussinessDe(),
      ),
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
              // readOnly: true,
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
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextMedium(
                        text: "Selected Category",
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        height: 42,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: black.withOpacity(0.1)),
                          color: white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Center(
                              child: Text(
                            salonCatName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          // child: DropdownButtonHideUnderline(
                          //   child: DropdownButton<String>(
                          //     isExpanded: true,
                          //     hint: Text(
                          //       'Select Category',
                          //       style: GoogleFonts.poppins(
                          //         fontSize: 13,
                          //         color: Colors.grey.shade600,
                          //       ),
                          //     ),
                          //     value: selectedId,
                          //     items: categories
                          //         .map((Category category) {
                          //       return DropdownMenuItem<String>(
                          //         value: category
                          //             .id, // Use the category's ID as the value
                          //         child: Text(
                          //           category.name,
                          //           style: GoogleFonts.poppins(
                          //             fontSize: 14,
                          //             color: Colors.black,
                          //           ),
                          //         ),
                          //       );
                          //     }).toList(),
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         selectedId = newValue;
                          //         selectedName = categories
                          //             .firstWhere((category) =>
                          //                 category.id == newValue)
                          //             .name;
                          //       });
                          //       print('Selected ID: $selectedId');
                          //     },
                          //   ),
                          // ),
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
            // CustomTextField(
            //   controller: salonLocationPin,
            //   borderColor: black.withOpacity(0.1),
            //   hintName: "Enter Address Pincode",
            // ),
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

            SizedBox(height: 20),
            TextMedium(
              text: "About Us",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: salonAboutUS,
              borderColor: black.withOpacity(0.1),
              hintName: "Tell us something about us",
            ),
            SizedBox(
              height: 20,
            ),
            Column(
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
                      height: 155,
                      width: 155,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        border: Border.all(
                          color: black.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: salonLo == null
                              ? Image.network(IMAGE_BASE_URL + salon['logo'])
                              : Image.file(salonLo!),
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
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextMedium(
                        text: "Salon Document",
                      ),
                    ),
                    Bounce(
                      onTap: () {
                        _pickPDF();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6.0),
                          child: Text(
                            "Update Documents",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  "*Long press to view the document...",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  height: 60,
                  child: salonDocs.isEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: salon['documents'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Align(
                              child: InkWell(
                                // onLongPress: () {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => DisplayPDFValss(
                                //               urll: IMAGE_BASE_URL +
                                //                   salon['documents'][index])));
                                // },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                      height: 45,
                                      width: 85,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.red),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.edit_document,
                                            color: white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "PDF",
                                            style: GoogleFonts.poppins(
                                              color: white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: salonDocs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Align(
                              child: InkWell(
                                // onLongPress: () {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => DisplayPDFValsspath(
                                //         urll: salonDocs[index],
                                //       ),
                                //     ),
                                //   );
                                // },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                      height: 45,
                                      width: 85,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.red),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.edit_document,
                                            color: white,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "PDF",
                                            style: GoogleFonts.poppins(
                                              color: white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            );
                          },
                        ),
                )
                // Bounce(
                //   onTap: () {
                //     // log(IMAGE_BASE_URL + salon['documents']);
                //     _pickPDF();
                //   },
                //   onLongPress: (val) {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => DisplayPDFValss(
                //             urll: IMAGE_BASE_URL +
                //                 salon['documents'][0])));
                //   },
                // child: Container(
                //     height: 45,
                //     width: 85,
                //     decoration: BoxDecoration(
                //       color:
                //           salonDoc != null ? Colors.green : Colors.red,
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(color: Colors.red),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.edit_document,
                //           color: white,
                //         ),
                //         SizedBox(
                //           width: 5,
                //         ),
                //         Text(
                //           "PDF",
                //           style: GoogleFonts.poppins(
                //             color: white,
                //             fontSize: 15,
                //             fontWeight: FontWeight.w400,
                //           ),
                //         )
                //       ],
                //     )),
                // )
                // CustomTextField(
                //   controller: ageC,
                //   hintName: "Enter Age",
                //   borderColor: black.withOpacity(0.1),
                //   type: "number",
                // ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Consumer<Maincontroller>(builder: (context, addressData, child) {
              return CustomContainer(
                onPressed: () {
                  if (salonNa.text == "" ||
                      salonCat.text == "" ||
                      addressData.getVendorCity == "" ||
                      addressData.getVendorAddress == "" ||
                      salonAddress.text == "" ||
                      addressData.getVendorPincode == "" ||
                      seating == "0") {
                    failed(
                        mesg: salonNa.text == ""
                            ? "Please enter salon name"
                            : salonCat.text == ""
                                ? "Please enter salon category"
                                : seating == "0"
                                    ? "Please select salon seating"
                                    : addressData.getVendorCity == ""
                                        ? "Please enter salon city"
                                        : addressData.getVendorAddress == ""
                                            ? "Please enter salon location"
                                            : salonAddress.text == ""
                                                ? "Please enter salon address"
                                                : addressData
                                                            .getVendorPincode ==
                                                        ""
                                                    ? "Please enter salon address pin"
                                                    : seating == "0"
                                                        ? "Please enter your salons seating"
                                                        : "Plese select the terms and conditions",
                        context: context);
                  } else {
                    update();
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
                textName: "Update",
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
}

// class DisplayPDFValss extends StatefulWidget {
//   String urll;
//   DisplayPDFValss({super.key, required this.urll});

//   @override
//   State<DisplayPDFValss> createState() => _DisplayPDFValssState();
// }

// class _DisplayPDFValssState extends State<DisplayPDFValss> {
//   // final String pdfUrl =
//   //     'http://193.203.160.181:1024/uploads/saloon/documents-1716459116909';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: white,
//         centerTitle: true,
//         title: Text(
//           "Salon Document",
//           style: GoogleFonts.poppins(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: primaryColor,
//           ),
//         ),
//       ),
//       body: PDF().fromUrl(
//         widget.urll,
//         placeholder: (progress) => Center(child: Text('$progress %')),
//         errorWidget: (error) => Center(child: Text(error.toString())),
//       ),
//     );
//   }
// }

// class DisplayPDFValsspath extends StatefulWidget {
//   File? urll;
//   DisplayPDFValsspath({super.key, required this.urll});

//   @override
//   State<DisplayPDFValsspath> createState() => _DisplayPDFValsspathState();
// }

// class _DisplayPDFValsspathState extends State<DisplayPDFValsspath> {
//   final Completer<PDFViewController> _controller =
//       Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';

//   // final String pdfUrl =
//   //     'http://193.203.160.181:1024/uploads/saloon/documents-1716459116909';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: white,
//         centerTitle: true,
//         title: Text(
//           "Salon Document",
//           style: GoogleFonts.poppins(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: primaryColor,
//           ),
//         ),
//       ),
//       body: PDFView(
//         filePath: widget.urll!.path,
//         enableSwipe: true,
//         swipeHorizontal: true,
//         autoSpacing: false,
//         pageFling: false,
//         onRender: (_pages) {
//           setState(() {
//             pages = _pages;
//             isReady = true;
//           });
//         },
//         onError: (error) {
//           print(error.toString());
//         },
//         onPageError: (page, error) {
//           print('$page: ${error.toString()}');
//         },
//         onViewCreated: (PDFViewController pdfViewController) {
//           // _controller.complete(pdfViewController);
//         },
//         // onPageChanged: (int page, int total,_) {
//         //   print('page change: $page/$total');
//         // },
//       ),
//     );
//   }
// }
