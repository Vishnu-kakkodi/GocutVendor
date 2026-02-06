// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:gocut_vendor/color/colors.dart';
// import 'package:gocut_vendor/repo/repos.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Policy extends StatefulWidget {
//   Policy({super.key, required this.title});
//   String title;
//   @override
//   State<Policy> createState() => _PolicyState();
// }

// class _PolicyState extends State<Policy> {
//   @override
//   void initState() {
//     get_policies(context, (response) {
//       setState(() {
//         policies = response['policies'];
//       });

//       print("the policeis : ${policies}");
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
//           child: policies.isEmpty
//               ? Container(
//                   height: 50,
//                   child: Align(
//                       child: CircularProgressIndicator(
//                     color: primaryColor,
//                   )))
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     widget.title == "Privacy Policy"
//                         ? HtmlWidget(policies['privacyPolicy'])
//                         : widget.title == "Terms & Conditions"
//                             ? HtmlWidget(policies['termsConditions'])
//                             : HtmlWidget(policies['refundPolicy'])
//                     //policies
//                     // Center(
//                     //     child:
//                     //         Text("Refund policy is still under construction"))
//                   ],
//                 ),
//         ),
//       ),
//       appBar: AppBar(
//         titleSpacing: 0,
//         backgroundColor: Colors.white,
//         title: Text(
//           widget.title,
//           style: GoogleFonts.poppins(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: primaryColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
