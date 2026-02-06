import 'package:flutter/material.dart';

class Maincontroller with ChangeNotifier {
  String _vendorAddress = '';
  String get getVendorAddress => _vendorAddress;
  String _vendorPincode = '';
  String get getVendorPincode => _vendorPincode;
  String _vendorCity = '';
  String get getVendorCity => _vendorCity;
  double _vendorLat = 0;
  double get getVendorLat => _vendorLat;
  double _vendorLog = 0;
  double get getVendorLog => _vendorLog;
  toggleVendorAddress(
      String address, String pincode, String city, double lat, double lan) {
    _vendorAddress = address;
    _vendorPincode = pincode;
    _vendorCity = city;
    _vendorLat = lat;
    _vendorLog = lan;

    notifyListeners();
  }
}
