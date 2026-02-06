import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

class MakeARequest extends StatefulWidget {
  const MakeARequest({super.key});

  @override
  State<MakeARequest> createState() => _MakeARequestState();
}

class _MakeARequestState extends State<MakeARequest> {
  //_upload_image
  File? _upload_image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);
      setState(() {
        this._upload_image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Exception occured");
    }
  }

  //_upload_image
  String dropdownvalue = 'Reason';
  var items = [
    'Reason',
    '1',
    '2',
  ];
  int count = 1;

  TextEditingController _descrip = TextEditingController();
  TextEditingController _subject = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Support",
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // Handle onPressed
          },
          icon: Icon(
            Icons.arrow_back,
            size: 24,
            color: black,
            // You can adjust the size and color of the icon here
          ),
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          // decoration: BoxDecoration(gradient: gradient_talegreen),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.3), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _subject,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                          ),
                      decoration: InputDecoration(
                        hintText: "Subject..",
                        hintStyle:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: black,
                                  fontFamily: "PopR",
                                ),
                        filled: true,
                        fillColor: white.withOpacity(0.7),
                        contentPadding: EdgeInsets.only(
                            left: 12, right: 0, top: 10, bottom: 0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: white.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: white.withOpacity(0.1))),
                      ),
                      // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      // keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: _upload_image == null
                        ? Container(
                            height: 46,
                            width: 135,
                            decoration: BoxDecoration(
                                color: white,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Upload",
                                  style: TextStyle(
                                      fontFamily: "PopR",
                                      color: black,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                // Text(
                                //   "Image",
                                //   style: TextStyle(
                                //       fontFamily: "PopR",
                                //       color: black,
                                //       fontSize: 13),
                                // ),
                                Icon(
                                  Icons.upload,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            )
                            // : ClipRRect(
                            //     borderRadius: BorderRadius.circular(10),
                            //     child: Image.file(
                            //       _upload_image!,
                            //       fit: BoxFit.fill,
                            //     ),
                            //   ),
                            )
                        : Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(
                                      _upload_image!,
                                    ))),
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.3), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _descrip,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                          ),
                      decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: black,
                                  fontFamily: "PopR",
                                ),
                        filled: true,
                        fillColor: white.withOpacity(0.7),
                        contentPadding: EdgeInsets.only(
                            left: 12, right: 0, top: 10, bottom: 0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: white.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: white.withOpacity(0.1))),
                      ),
                      // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      // keyboardType: TextInputType.number,
                      maxLines: 9,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_subject.text == "" ||
                              _upload_image == null ||
                              _descrip.text == "") {
                            failed(
                                mesg: _subject.text == ""
                                    ? "Please enter subject"
                                    : _upload_image == null
                                        ? "Please upload image"
                                        : "Please enter description",
                                context: context);
                          } else {
                            await addReq(
                                context: context,
                                reason: _subject.text,
                                image: _upload_image,
                                description: _descrip.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Container(
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    color: black.withOpacity(0.4)),
                                BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius: 0,
                                    color: black.withOpacity(0.1))
                              ],
                              borderRadius: BorderRadius.circular(30),
                              gradient: sharp_green_gradeint),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontFamily: "PopM",
                                  color: white,
                                  fontSize: 18),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
