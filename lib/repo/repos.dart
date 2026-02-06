import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gocut_vendor/constants/constant.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:gocut_vendor/lib/globals/data-maps/data-maps.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:shared_preferences/shared_preferences.dart';

//:::::::::::::::::::::::::::::::::SEND USER OTP::::::::::::::::::::::::::::://

Future sendOTp(context, String number, String fcmToken,
    Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse(sendOTP));
  request.body = json.encode({
    "userPhone": number,
    "fcm_token": fcmToken,
  });
  request.headers.addAll(headers);
  print("pinting the login details${request.body}");

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    print('fxsgcjac');
    success(mesg: decodedMap['message'], context: context);

    await updateCallback(decodedMap);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

//:::::::::::::::::::::::::::::::::VERIFY USER OTP::::::::::::::::::::::::::::://

Future verifydOTp(context, String idd, String otp,
    Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse(verifyOTP));
  request.body = json.encode({
    "mobileNumber": idd,
    "otp": otp,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    print('fxsgcjac');
    success(mesg: decodedMap['message'], context: context);

    await updateCallback(decodedMap);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

//:::::::::::::::::::::::::::::::::Register Vendor Business::::::::::::::::::::::::::::://

// Future registerVendorBusin(
//     context,
//     String salonName,
//     String salonNuber,
//     String seating,
//     String street,
//     String cityNam,
//     double lat,
//     double long,
//     String addressNam,
//     String addressNamPin,
//     String catID,
//     File? logo,
//     File? doc,
//     Function(Map<String, dynamic>) updateCallback) async {
//   EasyLoading.show();
//   var headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $accessToken'
//   };
//   var request = http.MultipartRequest('POST', Uri.parse(regiterBusiness));

//   request.fields.addAll({
//     'salooName': salonName,
//     'mobileNumber': salonNuber,
//     'seating': seating,
//     'city': cityNam,
//     'address': addressNam,

//     /// location
//     'street': street,

//     ///  address
//     'pincode': addressNamPin,
//     'longitude': lat.toString(),
//     'latitude': long.toString(),
//     'categoryId': catID,
//   });
//   request.files.add(await http.MultipartFile.fromPath('logo', logo!.path));
//   doc == null
//       ? null
//       : request.files
//           .add(await http.MultipartFile.fromPath('documents', doc!.path));
//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     EasyLoading.dismiss();
//     var responseString = await response.stream.bytesToString();
//     final decodedMap = json.decode(responseString);
//     print('fxsgcjac');
//     success(mesg: decodedMap['message'], context: context);

//     await updateCallback(decodedMap);
//   } else {
//     EasyLoading.dismiss();
//     var responseString = await response.stream.bytesToString();
//     final decodedMap = json.decode(responseString);
//     failed(mesg: decodedMap['message'], context: context);
//   }
// }



// Future registerVendorBusin(
//   context,
//   String salonName,
//   String salonNuber,
//   String seating,
//   String street,
//   String cityNam,
//   double lat,
//   double long,
//   String addressNam,
//   String addressNamPin,
//   String catID,
//   File? logo,
//   File? doc,
//   Function(Map<String, dynamic>) updateCallback,
// ) async {
//   EasyLoading.show();

//   var headers = {
//     'Authorization': 'Bearer $accessToken',
//   };

//   var request =
//       http.MultipartRequest('POST', Uri.parse(regiterBusiness));

//   request.fields.addAll({
//     'salooName': salonName,
//     'mobileNumber': salonNuber,
//     'seating': seating,
//     'city': cityNam,
//     'address': addressNam,
//     'street': street,
//     'pincode': addressNamPin,
//     'longitude': lat.toString(),
//     'latitude': long.toString(),
//     'categoryId': catID,
//   });

//   if (logo != null) {
//     request.files.add(
//       await http.MultipartFile.fromPath('logo', logo.path),
//     );
//   }

//   if (doc != null) {
//     request.files.add(
//       await http.MultipartFile.fromPath('documents', doc.path),
//     );
//   }

//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   /// ✅ READ RESPONSE BODY ONCE
//   final responseBody = await response.stream.bytesToString();

//   /// ✅ PRINT FULL RESPONSE
//   print("STATUS CODE: ${response.statusCode}");
//   print("RESPONSE BODY: $responseBody");

//   final decodedMap = json.decode(responseBody);

//   EasyLoading.dismiss();

//   if (response.statusCode == 200) {
//     success(mesg: decodedMap['message'], context: context);
//     await updateCallback(decodedMap);
//   } else {
//     failed(mesg: decodedMap['message'], context: context);
//   }
// }




Future registerVendorBusin(
  context,
  String salonName,
  String salonNuber,
  String seating,
  String street,
  String cityNam,
  double lat,
  double long,
  String addressNam,
  String addressNamPin,
  String catID,
  File? logo,
  File? doc,
  Function(Map<String, dynamic>) updateCallback,
) async {
  EasyLoading.show();

  var headers = {
    'Authorization': 'Bearer $accessToken',
  };

  var request =
      http.MultipartRequest('POST', Uri.parse(regiterBusiness));

  request.fields.addAll({
    'salooName': salonName,
    'mobileNumber': salonNuber,
    'seating': seating,
    'city': cityNam,
    'address': addressNam,
    'street': street,
    'pincode': addressNamPin,
    'longitude': lat.toString(),
    'latitude': long.toString(),
    'categoryId': catID,
  });

  if (logo != null) {
    request.files.add(
      await http.MultipartFile.fromPath('logo', logo.path),
    );
  }

  if (doc != null) {
    request.files.add(
      await http.MultipartFile.fromPath('documents', doc.path),
    );
  }

  request.headers.addAll(headers);

  // 🔹 PRINT PAYLOAD (FIELDS)
  debugPrint("=== REQUEST FIELDS ===");
  request.fields.forEach((key, value) {
    debugPrint("$key : $value");
  });

  // 🔹 PRINT PAYLOAD (FILES)
  debugPrint("=== REQUEST FILES ===");
  for (var file in request.files) {
    debugPrint(
      "field: ${file.field}, "
      "filename: ${file.filename}, "
      "length: ${file.length}",
    );
  }

  // 🔹 PRINT HEADERS
  debugPrint("=== REQUEST HEADERS ===");
  request.headers.forEach((key, value) {
    debugPrint("$key : $value");
  });

  // 🔹 SEND REQUEST
  http.StreamedResponse response = await request.send();

  /// ✅ READ RESPONSE BODY ONCE
  final responseBody = await response.stream.bytesToString();

  /// ✅ PRINT RESPONSE
  debugPrint("STATUS CODE: ${response.statusCode}");
  debugPrint("RESPONSE BODY: $responseBody");

  final decodedMap = json.decode(responseBody);

  EasyLoading.dismiss();

  if (response.statusCode == 200) {
    success(mesg: decodedMap['message'], context: context);
    await updateCallback(decodedMap);
  } else {
    failed(mesg: decodedMap['message'], context: context);
  }
}



//:::::::::::::::::::::::::::::::::Register Vendor::::::::::::::::::::::::::::://

Future registerVendor(context, String name, String email, String designatiom,
    Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken'
  };
  var request = http.MultipartRequest('POST', Uri.parse(regiterVendor));

  request.fields.addAll({
    'name': name,
    'email': email,
    'designation': designatiom,
  });
  // request.files.add(await http.MultipartFile.fromPath('logo', logo!.path));
  // request.files.add(await http.MultipartFile.fromPath('documents', doc!.path));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    print('fxsgcjac');
    // success(mesg: decodedMap['message'], context: context);

    await updateCallback(decodedMap);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

//:::::::::::::::::::::::::::::::::Get Profile ::::::::::::::::::::::::::::://

get_profile(context, Function(Map<String, dynamic>) updateCallback) async {
  print('get vendor profile called');
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request('POST', Uri.parse(vendor_Profile));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);

    // success(mesg: decodedMap['message'], context: context);

    await updateCallback(decodedMap);
    print("the profile data : ${vendor_data}");
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

//:::::::::::::::::::::::::::::::::Get Bank Details::::::::::::::::::::::::::::://

get_bankDetails(context, Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};

  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/bank/getbankdetails'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  print("heter");

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);

    // success(mesg: decodedMap['message'], context: context);

    await updateCallback(decodedMap);
    print("the bank data : ${bank_details}");
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

//:::::::::::::::::::::::::::::::::Update Bank Details::::::::::::::::::::::::::::://

update_bankDetails(context, String accNumber, String bName, String branch,
    String ifsc, String dhsbj) async {
  EasyLoading.show();
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };
  var request =
      http.Request('PUT', Uri.parse('$BASE_URL/vendor/bank/updatebankdetails'));
  request.bodyFields = {
    'accountHolderName': dhsbj,
    'accountNumber': accNumber,
    'bankName': bName,
    'branch': branch,
    'IfscCode': ifsc
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);

    success(mesg: decodedMap['message'], context: context);

    print("the bank data : ${bank_details}");
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

//:::::::::::::::::::::::::::::::::Get Service Request::::::::::::::::::::::::::::://

get_supportReqs(context, Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request('POST', Uri.parse(supportReqs));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    await updateCallback(decodedMap);
    // success(mesg: decodedMap['message'], context: context);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

addReq(
    {required BuildContext context,
    required String reason,
    required File? image,
    required String description}) async {
  EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.MultipartRequest(
      'POST', Uri.parse('$BASE_URL/vendor/support/addvendorsupport'));
  request.fields.addAll({'reason': reason, 'description': description});
  request.files.add(await http.MultipartFile.fromPath('image', image!.path));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    await get_supportReqs(context, (response) {
      support_reqs = response['vendorrequests'];
    });
    Navigator.pop(context);
    success(mesg: decodedMap['message'], context: context);
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

get_staff(context, Function(Map<String, dynamic>) updateCallback) async {
  // EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/staff/getAllstaff'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    print("---->> ${decodedMap}");
    await updateCallback(decodedMap);
    // success(mesg: decodedMap['message'], context: context);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

get_staffss(context, Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/staff/getAllstaff'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    print("---->> ${decodedMap}");
    EasyLoading.dismiss();
    await updateCallback(decodedMap);
    Navigator.pop(context);
    // success(mesg: decodedMap['message'], context: context);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

add_staff(context,
    {required String name,
    required String phone,
    required String alrNumber,
    required String email,
    required String age,
    required String gender,
    required String expert,
    File? image,
    File? pdf}) async {
  EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.MultipartRequest(
      'POST', Uri.parse('$BASE_URL/vendor/staff/addstaff'));
  request.fields.addAll({
    'name': name,
    'mobileNumber': phone,
    'altMobileNumber': alrNumber,
    'email': email,
    'age': age,
    'gender': gender,
    'expertIn': expert
  });
  pdf == null
      ? ""
      : request.files
          .add(await http.MultipartFile.fromPath('documents', pdf!.path));
  image == null
      ? ""
      : request.files
          .add(await http.MultipartFile.fromPath('image', image!.path));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("------> ${request.fields}");
  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);

    success(mesg: decodedMap['message'], context: context);
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

Map policies = {};
get_policies(context, Function(Map<String, dynamic>) updateCallback) async {
  // EasyLoading.show();
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};

  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/getvendorpolicies'));
  request.bodyFields = {'type': 'Vendor'};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  request.headers.addAll(headers);

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    await updateCallback(decodedMap);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

// get all combos

get_combos(context, Function(Map<String, dynamic>) updateCallback) async {
  showLoading();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request('POST',
      Uri.parse('$BASE_URL/vendor/combo/getallvendorcombos?searchQuery='));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    print("----->> ${decodedMap}");
    // success(mesg: decodedMap['message'], context: context);
    await updateCallback(decodedMap);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    print("----->> ${decodedMap}");
    failed(mesg: decodedMap['message'], context: context);
  }
}

// add combo

add_combo(context, String s_id, String cat_id, String combo_name, String disc,
    String start_Date, String end_Date, String) async {
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };
  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/combo/addcombo'));
  request.bodyFields = {
    'serviceId': '65c20a7915f200c652ff281c',
    'categoryId': '65bcde7aba321e38de818fcb',
    'comboName': 'special',
    'description': 'the gocut description',
    'startDate': '04-04-2024',
    'endDate': '09-04-2024',
    'serviceValue': '400',
    'comboPrice': '600'
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

// get campaings
List all_campaings = [];
get_capaings(context, Function(Map<String, dynamic>) updateCallback) async {
  print("the camps res: called");
  EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request(
      'POST',
      Uri.parse(
          '$BASE_URL/vendor/campaign/getallvendorcampaigns?searchQuery='));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("the camps res: ${response.statusCode}");
  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    await updateCallback(decodedMap);
    EasyLoading.dismiss();
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

get_capaingsss(context, Function(Map<String, dynamic>) updateCallback) async {
  print("the camps res: called");
  EasyLoading.show();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request(
      'POST',
      Uri.parse(
          '$BASE_URL/vendor/campaign/getallvendorcampaigns?searchQuery='));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("the camps res: ${response.statusCode}");
  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    await updateCallback(decodedMap);
    EasyLoading.dismiss();
    Navigator.pop(context);
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

// add discounts

add_discount(
    context,
    String cat_name,
    String serv_name,
    String camp_name,
    String disc,
    String start_Date,
    String end_Date,
    String s_val,
    String discount,
    String discountImage) async {
  EasyLoading.show();
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };
  var request = http.MultipartRequest(
      'POST', Uri.parse('$BASE_URL/vendor/campaign/addcampaign'));
  request.fields.addAll({
    'serviceName': serv_name,
    'categoryName': cat_name,
    'campaignName': camp_name,
    'description': disc,
    'startDate': start_Date,
    'endDate': end_Date,
    'serviceValue': s_val,
    'discount': discount
  });

  discountImage == ""
      ? null
      : request.files
          .add(await http.MultipartFile.fromPath('image', discountImage));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    success(mesg: decodedMap['message'], context: context);
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

// get plans
List all_plans = [];
get_plans(context, Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();
  // showLoading();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/getplansdata'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    await updateCallback(decodedMap);
    // success(mesg: decodedMap['message'], context: context);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

// add wallet

add_wallet(context, String amount) async {
  EasyLoading.show();
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };
  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/wallet/paywallet'));
  request.bodyFields = {'amount': amount};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("----> the amount ${amount}");
  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    Navigator.pop(context);
    success(mesg: decodedMap['message'], context: context);
    get_wallet(context, (response) {});
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

// get wallet

get_wallet(context, Function(Map<String, dynamic>) updateCallback) async {
  showLoading();
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request(
      'POST', Uri.parse('$BASE_URL/vendor/wallet/getallwalletrequests'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    await updateCallback(decodedMap);
    EasyLoading.dismiss();
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

with_draw({required BuildContext context, required String amount}) async {
  showLoading();
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };
  var request = http.Request(
      'POST', Uri.parse('$BASE_URL/vendor/wallet/addwalletrequest'));
  request.bodyFields = {
    'amount': amount,
    'description': '',
    'transactionId': ''
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);

    success(mesg: decodedMap['message'], context: context);
    get_wallet(context, (response) {});
  } else {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    failed(mesg: decodedMap['message'], context: context);
  }
}

upadate_profile(context, String name, String email, String designation,
    String active, File? image) async {
  showLoading();

  var headers = {'Authorization': 'Bearer $accessToken'};

  var request = http.MultipartRequest(
      'PUT', Uri.parse('$BASE_URL/vendor/auth/editvendorprofile'));

  request.fields.addAll({
    'name': name,
    'email': email,
    'designation': designation,
    'status': active
  });

  image == null
      ? ""
      : request.files
          .add(await http.MultipartFile.fromPath('image', image!.path));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  print("the details -- > ${request.fields}");

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    success(mesg: decodedMap['message'], context: context);
  } else {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    failed(mesg: decodedMap['message'], context: context);
  }
}

// log out

log_out(context) async {
  showLoading();

  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };

  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/auth/vendorlogut'));

  request.bodyFields = {
    // 'vendorId': '660bff09e47a3eac5a4b30ed'
  };

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    SharedPreferences storeData = await SharedPreferences.getInstance();

    storeData.clear();

    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LogIn()), (route) => false);

    success(mesg: decodedMap['message'], context: context);
  } else {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    failed(mesg: decodedMap['message'], context: context);
  }
}

// get vendor pofile
get_venodProfile(context, Function(Map<String, dynamic>) updateCallback) async {
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/auth/getvendorprofile'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);
  } else {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    failed(mesg: decodedMap['message'], context: context);
  }
}

Future<void> addImageees(context, List imagePaths,
    Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();

  var headers = {'Authorization': 'Bearer $accessToken'};

  var request = http.MultipartRequest(
      'POST', Uri.parse('$BASE_URL/vendor/gallery/addgallery'));

  // Iterate through each image path and add it to the request
  for (String imagePath in imagePaths) {
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
  }

  print(request.fields);

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  print(response.statusCode);

  if (response.statusCode == 200) {
    EasyLoading.dismiss();

    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    success(mesg: decodedMap['message'], context: context);

    await updateCallback(decodedMap);
  } else {
    EasyLoading.dismiss();

    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);
    debugPrint(decodedMap);

    failed(mesg: decodedMap['message'], context: context);
  }
}

//:::::::::::::::::::::::::::::::::Add Image::::::::::::::::::::::::::::://

Future getImagesGall(
    context, Function(Map<String, dynamic>) updateCallback) async {
  EasyLoading.show();

  var headers = {'Authorization': 'Bearer $accessToken'};

  var request = http.MultipartRequest(
      'POST', Uri.parse('$BASE_URL/vendor/gallery/getimages'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    EasyLoading.dismiss();

    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    success(mesg: decodedMap['message'], context: context);

    await updateCallback(decodedMap);
  } else {
    EasyLoading.dismiss();

    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    failed(mesg: decodedMap['message'], context: context);
  }
}

// delete combo

delete(context, String? id) async {
  var headers = {'Authorization': 'Bearer $accessToken'};
  var request = http.Request(
      'DELETE', Uri.parse('$BASE_URL/vendor/campaign/deletecampaign/${id}'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("the dtle data  : ${id}");
  if (response.statusCode == 200) {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    success(mesg: decodedMap['message'], context: context);
  } else {
    EasyLoading.dismiss();
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    failed(mesg: decodedMap['message'], context: context);
  }
}

// edit discount

edit_discount(context,
    {required String c_name,
    required String disc,
    required String s_date,
    required String e_Date,
    required String s_value,
    required String discount,
    required String ctegory,
    required String serviceaname,
    required String id,
    required String discountImage}) async {
  showLoading();
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };
  var request = http.MultipartRequest(
      'PUT', Uri.parse('$BASE_URL/vendor/campaign/editcampaign/${id}'));
  request.fields.addAll({
    'serviceName': serviceaname,
    'categoryName': ctegory,
    'campaignName': c_name,
    'description': disc,
    'startDate': s_date,
    'endDate': e_Date,
    'serviceValue': s_value,
    'discount': discount
  });
  discountImage == ""
      ? null
      : request.files
          .add(await http.MultipartFile.fromPath('image', discountImage));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  // print("the data: ${request.bodyFields}  ${id}");
  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);
    Navigator.pop(context);
    success(mesg: decodedMap['message'], context: context);
  } else {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    failed(mesg: decodedMap['message'], context: context);
  }
}

// salon profile
get_salon(context, Function(Map<String, dynamic>) updateCallback) async {
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Bearer $accessToken'
  };
  var request =
      http.Request('POST', Uri.parse('$BASE_URL/vendor/auth/getsalonprofile'));
  request.bodyFields = {'vendorId': '${vendor_data['_id']}'};
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);
    await updateCallback(decodedMap);
    EasyLoading.dismiss();
  } else {
    var responseString = await response.stream.bytesToString();

    final decodedMap = json.decode(responseString);

    failed(mesg: decodedMap['message'], context: context);
  }
}
