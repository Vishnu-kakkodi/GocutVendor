import 'package:flutter/material.dart';

//Main Colors

Color primaryColor = Color(0xFF63183F);

Color secondaryColor = Color(0xFFF77E7D);
Color thirdColor = Color(0xFFF747474);
Color fourthColor = Color(0xFFF331B1B);

Color blue = Color(0xFFF2E4882);
Color red = Color(0xFFFFF0000);
Color green = Colors.green;
Color silver_grey = Color(0xFFFD9D9D9);

//Basic colors

Color black = Color(0xFF000000);
Color white = Color(0xFFFFFFFF);

//==================Gradients===============//

Gradient sharp_green_gradeint = LinearGradient(
  colors: [primaryColor, secondaryColor],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

Gradient sharp_red_gradeint = LinearGradient(
  colors: [Colors.red, Colors.red.shade900],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
