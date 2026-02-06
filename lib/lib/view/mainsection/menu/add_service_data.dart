import 'dart:convert';
import 'dart:io';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddServiceMannual extends StatefulWidget {
  const AddServiceMannual({super.key});

  @override
  State<AddServiceMannual> createState() => _AddServiceMannualState();
}

class _AddServiceMannualState extends State<AddServiceMannual> {
  TextEditingController serName = TextEditingController();
  TextEditingController serPrice = TextEditingController();
  TextEditingController serPriceDis = TextEditingController();

  String? seating;
  String? seatingID;
  List<String> seatingList = [];
  List<String> seatingListID = [];

  File? serviceImage;

  Future<void> _pickserviceImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        serviceImage = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Simulating the servicessssMap data
    Map<dynamic, dynamic> servicessssMaps = servicessssMap;

    // Extracting the seatingList from servicessssMap
    seatingList = List<String>.from(
        servicessssMap['data'].map((item) => item['name'].toString()));

    seatingListID = List<String>.from(
        servicessssMap['data'].map((item) => item['_id'].toString()));

    seating = seatingList.isNotEmpty ? seatingList[0] : null;
    seatingID = seatingList.isNotEmpty ? seatingListID[0] : null;
  }

  Future addMannServicesss() async {
    EasyLoading.show();
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('$BASE_URL/vendor/service/service/addservice'));
    request.fields.addAll({
      'name': serName.text,
      'price': serPrice.text,
      'offerPrice': serPriceDis.text,
      'subcategoryId': seatingID!
    });

    request.files
        .add(await http.MultipartFile.fromPath('image', serviceImage!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      success(mesg: decodedMap['message'], context: context);
      getServices();

      print(await response.stream.bytesToString());
    } else {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
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
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      print(response.reasonPhrase);
    }
  }

  // [
  //   "Haircut",
  //   "Beard trim",
  //   "Shave",
  //   "Haircut & Shave",
  //   "Haircut & Beard trim",
  //   "Beard trim & Shave",
  //   "Haircut, Beard trim & Shave",
  //   "Facial",
  //   "Hot towel shave",
  //   "Head shave",
  //   "Neck shave",
  //   "Buzz cut",
  //   "Line-up",
  //   "Fade haircut",
  //   "Design",
  //   "Moustache trim",
  //   "Ear hair trim",
  //   "Eyebrow shaping",
  //   "Scalp massage",
  //   "Deep conditioning treatment"
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Add Services",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextMedium(
                text: "Service Type",
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
                          int selectedIndex = seatingList.indexOf(newValue!);
                          seatingID = seatingListID[selectedIndex];
                        });
                      },
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              TextMedium(
                text: "Service Name",
              ),
              SizedBox(
                height: 14,
              ),
              CustomTextField(
                hintName: "Enter service name",
                borderColor: black.withOpacity(0.1),
                controller: serName,
              ),
              SizedBox(
                height: 20,
              ),
              TextMedium(
                text: "Price",
              ),
              SizedBox(
                height: 14,
              ),
              CustomTextField(
                hintName: "Enter price",
                borderColor: black.withOpacity(0.1),
                controller: serPrice,
                type: 'number',
              ),
              SizedBox(
                height: 20,
              ),
              TextMedium(
                text: "Discount Price",
              ),
              SizedBox(
                height: 14,
              ),
              CustomTextField(
                hintName: "Enter amount",
                borderColor: black.withOpacity(0.1),
                controller: serPriceDis,
                type: 'number',
              ),
              SizedBox(
                height: 20,
              ),
              TextMedium(
                text: "Add Service image",
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _pickserviceImage();
                },
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: serviceImage == null
                      ? Icon(Icons.add_a_photo)
                      : Image.file(serviceImage!),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bounce(
        onTap: () {
          if (serName.text == "") {
            failed(mesg: "Service name can not be empty", context: context);
          } else if (serPrice.text == "") {
            failed(mesg: "Service price can not be empty", context: context);
          } else if (serPriceDis.text == "") {
            failed(
                mesg: "Service discount amount can not be empty",
                context: context);
          } else if (serviceImage == null) {
            failed(mesg: "Please select servie image", context: context);
          } else {
            addMannServicesss();
          }
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => AddServices()));
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
    );
  }
}
