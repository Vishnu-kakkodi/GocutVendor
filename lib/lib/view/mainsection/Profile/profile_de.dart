import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = TextEditingController(text: vendor_data['name']);
    phone = TextEditingController(text: vendor_data['mobileNumber']);
    email = TextEditingController(text: vendor_data['email']);
    designation = TextEditingController(text: vendor_data['designation']);
  }

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController designation = TextEditingController();

  File? profile_pic;

  Future<void> pick_img() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        profile_pic = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
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
                child:InkWell(
                            onTap: () {
                              pick_img();
                            },
                  child: Stack(
                    children: [
                      profile_pic == null
                          ? InkWell(
                              onTap: () {
                                pick_img();
                              },
                              child: Align(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    image: DecorationImage(
                                      image: vendor_data['image'] == ""
                                          ? NetworkImage(
                                              "https://beforeigosolutions.com/wp-content/uploads/2021/12/dummy-profile-pic-300x300-1.png")
                                          : NetworkImage(
                                              IMAGE_BASE_URL +
                                                  '${vendor_data['image']}',
                                            ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(
                                      profile_pic!,
                                    ))),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full name",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                  hintText: "Full Name",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: black,
                                  ),
                                  border: InputBorder.none),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: black,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mobile number",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        failed(
                            mesg:
                                "Please contact admin to change mobile number",
                            context: context);
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                enabled: false,
                                controller: phone,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    hintText: "Mobile number",
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: black,
                                    ),
                                    border: InputBorder.none,
                                    counterText: ""),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: black,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                  hintText: "Email address",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: black,
                                  ),
                                  border: InputBorder.none),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: black,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Designation",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              controller: designation,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: black,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                  hintText: "Enter Designation",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: black,
                                  ),
                                  border: InputBorder.none),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            InkWell(
              onTap: () async {
                if (name.text == "") {
                  failed(
                      mesg: "Name field name can not empty", context: context);
                  return;
                }
                if (phone.text == "") {
                  failed(
                      mesg: "Mobile number filed can not be empty",
                      context: context);
                  return;
                }

                if (phone.text.length < 10) {
                  failed(
                      mesg: "Please enter valid mobile number",
                      context: context);
                  return;
                }
                if (email.text == "") {
                  failed(
                      mesg: "Email field can not be empty", context: context);
                  return;
                }
                if (designation.text == "") {
                  failed(
                      mesg: "Designation field can not be empty",
                      context: context);
                  return;
                }

                await upadate_profile(context, name.text, email.text,
                    designation.text, "active", profile_pic);
                await get_profile(context, (response) {
                  setState(() {
                    vendor_data = response['vendorProfile'];
                  });
                });
                // update api
              },
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                ),
                child: Center(
                    child: Text(
                  "Update",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: white,
                  ),
                )),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
