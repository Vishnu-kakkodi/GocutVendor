import 'dart:ui';

import 'package:bounce/bounce.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/gradients.dart';
import 'package:gocut_vendor/lib/controllers/maincontroller.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
// import 'package:gocut_user/constants/colors.dart';
// import 'package:gocut_user/constants/gradients.dart';
// import 'package:gocut_user/view/constants/apiUrls.dart';
// import 'package:gocut_user/view/main-section/home/near-by-saloon/near-by-saloon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

failed({required String mesg, required context}) {
  EasyLoading.dismiss();
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: "${mesg}",
    ),
  );
}

success({required String mesg, required context}) {
  EasyLoading.dismiss();
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      message: "${mesg}",
    ),
  );
}

showLoading() {
  return EasyLoading.show(
    status: 'Loading...',
    maskType: EasyLoadingMaskType.custom,
  );
}
//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  TEXT WIDGET *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

class TextBold extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  final Color textColor;
  final double fontSize;
  final TextOverflow overFlow;

  TextBold({
    required this.text,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF000000), // Make black constant
    this.fontSize = 20,
    this.overFlow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overFlow,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w700,
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}

class TextSemiBold extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  final Color textColor;
  final double fontSize;
  final TextOverflow overFlow;

  TextSemiBold({
    required this.text,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF000000), // Make black constant
    this.fontSize = 18,
    this.overFlow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overFlow,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}

class TextMedium extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  final Color textColor;
  final double fontSize;
  final TextOverflow overFlow;

  TextMedium({
    required this.text,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF000000), // Make black constant
    this.fontSize = 16,
    this.overFlow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overFlow,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w500,
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}

class TextRegular extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color textColor;
  final double fontSize;
  final TextOverflow overFlow;

  TextRegular({
    required this.text,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF000000), // Make black constant
    this.fontSize = 14,
    this.overFlow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overFlow,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w400,
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  TEXT WIDGET *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  CONTAINER   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

class CustomContainer extends StatelessWidget {
  final VoidCallback onPressed;
  final Color buttonColor;
  final double radius;
  final Color textColor;

  final double height;
  final double width;
  final String textName;
  final String textFamily;
  final double textSize;
  final Widget? customChild; // Allow custom child widget

  CustomContainer({
    required this.onPressed,
    this.buttonColor = const Color(0xFF651D45),
    this.radius = 10,
    this.textColor = const Color(0xFFFFFFFF),
    this.height = 52,
    this.width = double.infinity,
    required this.textName,
    this.textFamily = "IntS",
    this.textSize = 18,
    this.customChild, // Include customChild in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: customChild ??
            Center(
              child: TextSemiBold(
                text: textName,
                textColor: textColor,
                fontSize: textSize,
              ),
            ),
      ),
    );
  }
}

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  CONTAINER   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  TEXTFIELD   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintName;
  final String type;
  final List<TextInputFormatter>? textInputFormatter;
  final bool readOnly;
  final double radius;
  final Color borderColor;

  const CustomTextField({
    Key? key,
     this.textInputFormatter,
    required this.controller,
    required this.hintName,
    this.type = "text",
    this.readOnly = false,
    required this.borderColor,
    this.radius = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 16,
            right: 0,
            bottom: 0,
          ),
          hintText: hintName,
          hintStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.4),
              fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
         inputFormatters: [
          
           if( type == "number" )  LengthLimitingTextInputFormatter(10),
     ...?textInputFormatter,
          ],
     
          
        keyboardType: type != "number" ? null : TextInputType.number,
      ),
    );
  }
}

class BankCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintName;
  final String type;
  final bool readOnly;
  final double radius;
  final Color borderColor;

  const BankCustomTextField({
    Key? key,
    required this.controller,
    required this.hintName,
    this.type = "text",
    this.readOnly = false,
    required this.borderColor,
    this.radius = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 16,
            right: 0,
            bottom: 0,
          ),
          hintText: hintName,
          hintStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.4),
              fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
        inputFormatters:
            type != "number" ? null : [LengthLimitingTextInputFormatter(14)],
        keyboardType: type != "number" ? null : TextInputType.number,
      ),
    );
  }
}

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  TEXTFIELD   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

// //*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  CAROSEL SLIDER   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

class ImageCarousel_Slider extends StatefulWidget {
  final List imageList;
  final Color indicatorColor;
  final double height;
  final String type;
  final Function(int)? onPageChanged;

  ImageCarousel_Slider({
    required this.imageList,
    this.indicatorColor = const Color(0xFFF77E7D),
    this.height = 159,
    this.type = "banners",
    this.onPageChanged,
  });

  @override
  State<ImageCarousel_Slider> createState() => _ImageCarousel_SliderState();
}

class _ImageCarousel_SliderState extends State<ImageCarousel_Slider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CarouselSlider.builder(
            itemCount: widget.imageList.length,
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        offset: Offset(1, 4),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(.0),
                        offset: Offset(1, 1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(IMAGE_BASE_URL +
                          widget.imageList[index]
                              [widget.type == "banners" ? "image" : "logo"]!),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: widget.height,
              aspectRatio: 16 / 9,
              viewportFraction: 0.85,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 900),
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });

                if (widget.onPageChanged != null) {
                  widget.onPageChanged!(index);
                }
              },
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageList.length,
            (index) => Container(
              width: currentIndex == index ? 20 : 5,
              height: 5,
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:
                    currentIndex == index ? widget.indicatorColor : silver_grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// //*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  CAROSEL SLIDER   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  SERVICES LISTVIEW BUILDER   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

class ServicesListviewBuilder extends StatelessWidget {
  final double width;
  final double height;
  final List image;
  final List name;
  final Color textColor;
  final String textFamily;
  final double textSize;
  final int listLength;
  final Function(int)? listviewOnTap;

  ServicesListviewBuilder(
      {required this.width,
      this.height = 60,
      required this.image,
      required this.name,
      this.listviewOnTap,
      required this.textColor,
      required this.textFamily,
      required this.textSize,
      required this.listLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      // color: red,
      padding: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: listLength,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Bounce(
                    scaleFactor: 0.87,
                    onTap: () {
                      listviewOnTap!(index);
                    },
                    child: Container(
                      width: width, // Use the width property here
                      child: Column(
                        children: [
                          Container(
                            height: height,
                            width: width, // Use the width property here
                            padding: EdgeInsets.all(height == 50 ? 0.0 : 1.5),
                            decoration: BoxDecoration(
                                gradient: primaryColor_gradient,
                                // shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      IMAGE_BASE_URL + image[index]['image'],
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: TextMedium(
                              text: name[index]['name'],
                              textColor: textColor,
                              textAlign: TextAlign.center,
                              fontSize: textSize,
                              // fontFamily: textFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  SERVICES LISTVIEW BUILDER   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  CUSTOM BOTTOM TAB BAR   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

class CustomBottomTabBarItem extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  CustomBottomTabBarItem({
    required this.imagePath,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Bounce(
        scaleFactor: 1.5,
        onTap: onTap,
        child: Ink(
          color: white,
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Container(
                height: 25,
                width: 25,
                child: imagePath == ""
                    ? null
                    : Image.asset(
                        imagePath,
                        color: isSelected == true ? primaryColor : null,
                        fit: BoxFit.fill,
                        // color: isSelected ? white : null,
                      ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                text,
                style: TextStyle(
                  fontFamily: "IntR",
                  color: isSelected ? secondaryColor : black,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 10,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 4,
                width: 22,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : null,
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>  CUSTOM BOTTOM TAB BAR   *>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>*>

String serviceaddress = "";
Future<void> getAddress(
    {required BuildContext context,
    required double lat,
    required double long}) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks[0];

      // Access more address details
      String address = [
        placemark.name,
        placemark.street,
        placemark.locality,
        placemark.subLocality,
        placemark.administrativeArea,
        placemark.subAdministrativeArea,
        placemark.postalCode,
        placemark.country,
        placemark.isoCountryCode,
        placemark.thoroughfare,
        placemark.subThoroughfare
      ].where((element) => element != null && element.isNotEmpty).join(', ');

      print("get all address from placemark${lat + long}");
      // Access more address details
      String street = placemark.street ?? '';
      String subLocality = placemark.subLocality ?? '';
      String locality = placemark.locality ?? '';
      String postalCode = placemark.postalCode ?? '';
      String country = placemark.country ?? '';
      String city = placemark.administrativeArea ?? '';

      // setState(() {
      Provider.of<Maincontroller>(context, listen: false)
          .toggleVendorAddress(address, postalCode, city, lat, long);
      // print("get all addresses${serviceaddress}");
      // serviceAddress.text = serviceaddress;
      // servicecity.text = locality;
      // servicelandMark.text = subLocality;
      // servicepincode.text = postalCode;
      // servicestate.text = state;
      // });
      EasyLoading.dismiss();

      // print("Detailed address: $serviceaddress");
    } else {
      // setState(() {
      serviceaddress = 'No address found';
      // });
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Future<Position?> getCurrentLocation({required BuildContext context}) async {
//   Position? position;
//   try {
//     // Check if location permission is granted
//     final permissionStatus = await Permission.location.request();
//     if (permissionStatus.isGranted) {
//       // Request the current position
//       position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );

//       // print("splashcurrentlat: ${position.latitude}, ${position.longitude}");

//       getAddress(
//           context: context, lat: position!.latitude, long: position.longitude);

//       // print("current lats: ${position.latitude}, ${position.longitude}");
//     } else {
//       final permissionStatus = await Permission.location.request();
//       // Handle the case where the user denied location permission
//       // print("Location permission denied.");
//       // print("currentlat: failed");
//     }
//   } catch (e) {
//     print("Error getting current location: $e");
//   }
//   return position;
// }

Future<Position?> getCurrentLocation({required BuildContext context}) async {
  // Check if location services are enabled
  print("locatino in from the app helllo");
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("Location services are disabled.");
    // return;
  }

  // Check location permission status
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permission denied.");
      // return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print(
        "Location permissions are permanently denied, we cannot request permissions.");
    // return;
  }

  // Fetch the current position if permissions are granted
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // print("splashcurrentlat: ${position.latitude}, ${position.longitude}");

    getAddress(
        context: context, lat: position!.latitude, long: position.longitude);

    // print("current lats: ${position.latitude}, ${position.longitude}");
  } catch (e) {
    print("Error getting current location: $e");
  }
  // return position;
}
