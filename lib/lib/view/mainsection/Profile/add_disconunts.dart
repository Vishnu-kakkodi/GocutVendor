import 'dart:io';
import 'package:bounce/bounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddDiscounts extends StatefulWidget {
  AddDiscounts({super.key});

  @override
  State<AddDiscounts> createState() => _AddDiscountsState();
}

class _AddDiscountsState extends State<AddDiscounts> {
  String genderD = "Select";
  var genderDs = ["Select", "Male", "Female", "Others"];
  String category = "Premium";
  var seatingList = ["Premium", 'Ordinary'];
  TextEditingController camp_name = TextEditingController();
  TextEditingController serv_name = TextEditingController();
  TextEditingController disc_name = TextEditingController();
  TextEditingController serv_val = TextEditingController();
  TextEditingController discount = TextEditingController();
  bool _check_box = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  DateTime end_Date = DateTime.now();
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

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        end_Date = picked;
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
          "Add Discounts",
          style: GoogleFonts.poppins(
            fontSize: 15,
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
              text: "Campaign Name",
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              controller: camp_name,
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
              controller: serv_name,
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
              controller: disc_name,
              // readOnly: true,
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
                      selectEndDate(context);
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
                                    child: Text(
                                        "${end_Date.toLocal()}".split(' ')[0]),
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
                          controller: serv_val,
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
                        width: double.infinity,
                        child: CustomTextField(
                          controller: discount,
                          type: 'number',
                          hintName: "Service Value",
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
              text: "Add Discount Image",
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
            //         value: category,
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
            //             category = newValue!;
            //           });
            //         },
            //       ),
            //     )),
            SizedBox(
              height: 40,
            ),
            CustomContainer(
              onPressed: () async {
                await add_discount(
                    context,
                    "",
                    // category,
                    serv_name.text,
                    camp_name.text,
                    disc_name.text,
                    _selectedDate.toString(),
                    end_Date.toString(),
                    serv_val.text,
                    discount.text,
                    salonLo == null ? "" : salonLo!.path);
                await get_capaingsss(context, (response) {
                  setState(() {
                    all_campaings = response['vendorcampaigns'];
                  });
                  print("the dtle data  : ${all_campaings}");
                });

                // Navigator.pop(context);
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
}
