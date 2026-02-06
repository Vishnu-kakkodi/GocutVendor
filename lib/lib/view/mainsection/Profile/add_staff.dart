import 'dart:io';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddStaff extends StatefulWidget {
  AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  TextEditingController searchCon = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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

  Future<void> _pickSalonPic() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        salonDoc = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickPDF() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        salonDoc = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

// name , phone, alte unum, email,age,

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController alt_number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: Text(
            "Add Staff",
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
                SizedBox(
                  height: 10,
                ),
                Bounce(
                  onTap: () {
                    _pickSalonLo();
                  },
                  child: Center(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: white,
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                image: salonLo == null
                                    ? DecorationImage(
                                        image: ExactAssetImage(
                                          'assets/images/dummypic.png',
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: FileImage(
                                          salonLo!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: white,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Name",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF9F9F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Name",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.3),
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Mobile Number",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF9F9F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Enter Mobile number",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.3),
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Alternate Mobile Number",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF9F9F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: alt_number,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          hintText: "Enter Alternate Mobile number",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.3),
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFF9F9F9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.3),
                        ),
                        hintText: "Enter email address",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Age",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: black,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF9F9F9),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: age,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter Age",
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.3),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextMedium(
                            text: "Gender",
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFF9F9F9),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  padding: EdgeInsets.only(
                                      left: 12, right: 0, top: 0, bottom: 0),
                                  isExpanded: true,
                                  dropdownColor: white,
                                  iconSize: 32,
                                  style: TextStyle(color: black, fontSize: 16),
                                  value: genderD,
                                  icon: Icon(
                                    Icons.expand_more,
                                    color: black,
                                    size: 25,
                                  ),
                                  items: genderDs.map((String? items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items!),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      genderD = newValue!;
                                    });
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextMedium(
                      text: "Expert In",
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFF9F9F9),
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
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextMedium(
                      text: "Document type",
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFF9F9F9),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            padding: EdgeInsets.only(
                                left: 12, right: 0, top: 0, bottom: 0),
                            isExpanded: true,
                            dropdownColor: white,
                            iconSize: 32,
                            style: TextStyle(color: black, fontSize: 16),
                            value: doucument_type,
                            icon: Icon(
                              Icons.expand_more,
                              color: black,
                              size: 25,
                            ),
                            items: doucuments_list.map((String? items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items!),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                doucument_type = newValue!;
                              });
                            },
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextMedium(
                            text: "Upload Document",
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Bounce(
                            onTap: () {
                              _pickSalonPic();
                            },
                            child: Container(
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: salonDoc != null
                                      ? Colors.green
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: salonDoc != null
                                        ? Colors.transparent
                                        : black.withOpacity(0.2),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    salonDoc != null
                                        ? "Documet Uploaded"
                                        : "Upload",
                                    style: TextStyle(
                                      fontFamily: "IntR",
                                      color: salonDoc != null ? white : black,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                  ),
                                )),
                          ),

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
                  height: 40,
                ),
                CustomContainer(
                  onPressed: () async {
                    // target
                    if (name.text.isEmpty) {
                      failed(
                        mesg: "Please enter the name.",
                        context: context,
                      );
                      return;
                    }

                    if (phone.text.isEmpty) {
                      failed(
                        mesg: "Please enter the phone number.",
                        context: context,
                      );
                      return;
                    }

                    if (phone.text.length < 10) {
                      failed(
                        mesg: "Ensure that the phone number is valid.",
                        context: context,
                      );
                      return;
                    }

                    if (alt_number.text.isEmpty) {
                      failed(
                        mesg: "Please enter the alternate number.",
                        context: context,
                      );
                      return;
                    }

                    if (alt_number.text.length < 10) {
                      failed(
                        mesg: "Ensure that the alternate number is valid.",
                        context: context,
                      );
                      return;
                    }

                    if (email.text.isEmpty) {
                      failed(
                        mesg: "Please enter the email.",
                        context: context,
                      );
                      return;
                    }

                    // Simple email validation
                    if (!email.text.contains('@') ||
                        !email.text.endsWith('.com')) {
                      failed(
                        mesg: "Please enter a valid email address.",
                        context: context,
                      );
                      return;
                    }

                    if (age.text.isEmpty) {
                      failed(
                        mesg: "Please enter the age.",
                        context: context,
                      );
                      return;
                    }

                    if (genderD == "Select") {
                      failed(
                        mesg: "Please select the gender.",
                        context: context,
                      );
                      return;
                    }

                    if (salonLo == null) {
                      failed(
                        mesg: "Please upload the staff profile image.",
                        context: context,
                      );
                      return;
                    }

                    if (salonDoc == null) {
                      failed(
                        mesg: "Please upload the staff image.",
                        context: context,
                      );
                      return;
                    }

                    await add_staff(
                      context,
                      image: salonLo,
                      pdf: salonDoc,
                      name: name.text,
                      phone: phone.text,
                      alrNumber: alt_number.text,
                      email: email.text,
                      age: age.text,
                      gender: genderD,
                      expert: seating,
                    );
                    //   await add_staff(context,
                    // name: name.text,
                    // phone: phone.text,
                    // alrNumber: alt_number.text,
                    // email: email.text,
                    // age: age.text,
                    // gender: genderD,
                    // expert: "Hair Transplant",
                    // image: salonLo,
                    // pdf: salonDoc);
                    await get_staffss(
                        context,
                        (reponse) => {
                              setState(() {
                                staff = reponse['staffs'];
                              })
                            });
                  },
                  textName: "Add Staff",
                  height: 42,
                ),
              ],
            ),
          ),
        ));
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
              text: "Campaign Name",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: salonNa,
              hintName: "Campaign Name",
              borderColor: black.withOpacity(0.1),
            ),
            SizedBox(
              height: 20,
            ),
            TextMedium(
              text: "Service",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: salonCOnt,
              readOnly: true,
              hintName: "Service name",
              borderColor: black.withOpacity(0.1),
            ),
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
              controller: salonCOnt,
              readOnly: true,
              hintName: "Description",
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
                      _selectDate(context);
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
                          controller: salonCat,
                          hintName: "Service Value",
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
                        text: "Discount",
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
              ],
            ),
            SizedBox(height: 20),
            TextMedium(
              text: "Category",
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
                    padding:
                        EdgeInsets.only(left: 12, right: 0, top: 0, bottom: 0),
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
            SizedBox(
              height: 40,
            ),
            CustomContainer(
              onPressed: () async {
                await add_staff(context,
                    name: name.text,
                    phone: phone.text,
                    alrNumber: alt_number.text,
                    email: email.text,
                    age: age.text,
                    gender: genderD,
                    expert: "Hair Transplant",
                    image: salonLo,
                    pdf: salonDoc);
                // await get_staffss(
                //     context,
                //     (reponse) => {
                //           setState(() {
                //             staff = reponse['staffs'];
                //           })
                //         });
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

  String genderD = "Select";
  var genderDs = ["Select", "Male", "Female", "Others"];
  String seating = "Hair Cut";
  var seatingList = ["Hair Cut", "Hair Coloring"];

  String doucument_type = "Pan Card";
  var doucuments_list = ["Pan Card", "Adhaar Card"];
  TextEditingController salonNa = TextEditingController();
  TextEditingController salonCOnt = TextEditingController();
  TextEditingController salonCat = TextEditingController();
  TextEditingController salonCity = TextEditingController();
  TextEditingController salonAddress = TextEditingController();

  TextEditingController fullNam = TextEditingController();
  TextEditingController emailAdd = TextEditingController();
  TextEditingController contactNum = TextEditingController();
  TextEditingController designation = TextEditingController();

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
