import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/constants/componets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchAddress extends StatefulWidget {
  SearchAddress({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        surfaceTintColor: white,
        centerTitle: true,
        leading: Bounce(
          scaleFactor: 0.87,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: TextSemiBold(
          text: "Search Address",
          fontSize: 18,
          textColor: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: "AIzaSyDuddNO8iwxTtghxnmDn1URNTpl265-_9M",
                inputDecoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 16, top: 0, right: 0, bottom: 0),
                  hintText: "Search your location",
                  hintStyle: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: primaryColor),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                debounceTime: 400,
                countries: ["in", "fr"],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) async {
                  // SharedPreferences set_latitude =
                  //     await SharedPreferences.getInstance();
                  // SharedPreferences set_longitude =
                  //     await SharedPreferences.getInstance();
                  try {
                    // Provider.of<MainController>(context, listen: false)
                    //     .toggleCurrentAddress(
                    //   lat: double.parse(prediction.lat.toString()),
                    //   long: double.parse(prediction.lng.toString()),
                    // );
                    getAddress(
                        context: context,
                        lat: double.parse(prediction.lat.toString()),
                        long: double.parse(prediction.lng.toString()));
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error parsing latitude or longitude: $e");
                  }
                },
                itemClick: (Prediction prediction) {
                  controller.text = prediction.description ?? "";
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: prediction.description?.length ?? 0));
                },
                seperatedBuilder: Divider(),
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 7),
                        Expanded(child: Text("${prediction.description ?? ""}"))
                      ],
                    ),
                  );
                },
                isCrossBtnShown: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
