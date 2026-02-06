import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get_bankDetails(
        context,
        (reponse) => {
              setState(() {
                bank_details = reponse['bank'];
                accountAcc =
                    TextEditingController(text: bank_details['accountNumber']);
                bankName =
                    TextEditingController(text: bank_details['bankName']);
                accountHol =
                    TextEditingController(text: bank_details['vendorName']);
                branch = TextEditingController(text: bank_details['branch']);
                ifscCode =
                    TextEditingController(text: bank_details['IfscCode']);
              })
            });
  }

  TextEditingController accountHol = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountAcc = TextEditingController();
  TextEditingController branch = TextEditingController();
  TextEditingController ifscCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          "Bank Details",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
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
                height: 18,
              ),
              TextMedium(
                text: "Account holder name",
              ),
              SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: accountHol,
                hintName: "Enter Bank Acc. holder name",
                borderColor: black.withOpacity(0.1),
              ),
              SizedBox(
                height: 20,
              ),
              TextMedium(
                text: "Bank Name",
              ),
              SizedBox(
                height: 14,
              ),
              CustomTextField(
                controller: bankName,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^[a-zA-Z ]*$')), // Allows only alphabets and spaces
                ],
                hintName: "Enter Bank Name",
                borderColor: black.withOpacity(0.1),
              ),
              SizedBox(
                height: 20,
              ),
              TextMedium(
                text: "Account Number",
              ),
              SizedBox(
                height: 14,
              ),
              // Container(
              //   height: 45,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(color: black.withOpacity(0.2)),
              //     color: white,
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Center(
              //       child: TextFormField(
              //         controller: accountAcc,
              //         keyboardType: TextInputType.number,
              //         maxLength: 14,
              //         decoration: InputDecoration(
              //           counterText: "",
              //           border: InputBorder.none,
              //           hintText: "983212567878",
              //           hintStyle: GoogleFonts.poppins(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w400,
              //             color: Colors.black.withOpacity(0.3),
              //           ),
              //           // enabledBorder: OutlineInputBorder(
              //           //   borderRadius: BorderRadius.circular(10),
              //           //   borderSide: BorderSide(color: black),
              //           // ),
              //           // focusedBorder: OutlineInputBorder(
              //           //   borderRadius: BorderRadius.circular(10),
              //           //   borderSide: BorderSide(color: black),
              //           // ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              CustomTextField(
                controller: accountAcc,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(16),
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Allows only alphabets and spaces
                ],
                hintName: "Enter Account Number",
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
                          text: "Branch",
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        CustomTextField(
                          controller: branch,
                          hintName: "Branch",
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'^[a-zA-Z ]*$')), // Allows only alphabets and spaces
                          ],
                          borderColor: black.withOpacity(0.1),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextMedium(
                          text: "IFSC Code",
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        CustomTextField(
                          controller: ifscCode,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'^[a-zA-Z0-9]*$')), // Allows only letters and digits
                          ],
                          hintName: "Enter IFSC Code",
                          borderColor: black.withOpacity(0.1),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
              CustomContainer(
                onPressed: () async {
                  if (accountHol.text == "") {
                    failed(
                        mesg: "Account Holder name can not empty",
                        context: context);
                    return;
                  }
                  if (bankName.text == "") {
                    failed(
                        mesg: "Bank name can not be empty", context: context);
                    return;
                  }
                  if (accountAcc.text == "") {
                    failed(
                        mesg: "Account number can not be empty",
                        context: context);
                    return;
                  }

                  if (accountAcc.text.length < 16) {
                    failed(
                        mesg: "Please enter valid account number",
                        context: context);
                    return;
                  }

                  if (branch.text == "") {
                    failed(
                        mesg: "Branch field can not be empty",
                        context: context);
                    return;
                  }

                  if (ifscCode.text == "") {
                    failed(
                        mesg: "IFSC Code can not be empty", context: context);
                    return;
                  }

                  if (ifscCode.text == "") {
                    failed(
                        mesg: "Please enter valid ifsc code", context: context);
                    return;
                  }

                  await update_bankDetails(
                      context,
                      accountAcc.text,
                      bankName.text,
                      branch.text,
                      ifscCode.text,
                      accountHol.text);
                  await get_wallet(context, (response) {
                    setState(() {
                      wallet_data = response;
                    });
                  });
                  Navigator.pop(context);
                  // get_bankDetails(
                  //     context,
                  //     (reponse) => {
                  //           setState(() {
                  //             bank_details = reponse['bank'];
                  //           })
                  //         });
                  if (bank_details.isNotEmpty) {
                    accountAcc = TextEditingController(
                        text: bank_details['accountNumber']);
                    bankName =
                        TextEditingController(text: bank_details['bankName']);
                    accountHol =
                        TextEditingController(text: bank_details['vendorName']);
                    branch =
                        TextEditingController(text: bank_details['branch']);
                    ifscCode =
                        TextEditingController(text: bank_details['IfscCode']);
                  }
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
      ),
    );
  }
}
