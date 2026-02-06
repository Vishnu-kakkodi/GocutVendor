import 'dart:async';
import 'dart:math';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/lib/controllers/bottomNavigation_controller.dart';
import 'package:gocut_vendor/lib/globals/mapss_data.dart';
import 'package:gocut_vendor/lib/view/auth/login.dart';
import 'package:gocut_vendor/lib/view/constants/apiUrls.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/bank_de.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/dashboard.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/dicsounts.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/gallery.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/my_combo.dart.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/my_satff.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/orderhistory.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/plans.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/profile_de.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/salon_profile.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/settings.dart';
import 'package:gocut_vendor/lib/view/mainsection/Profile/support_scr.dart';
import 'package:gocut_vendor/lib/view/mainsection/mainsection.dart';
import 'package:gocut_vendor/lib/view/mainsection/menu/menu.dart';
import 'package:gocut_vendor/repo/repos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, IconData> itemIcons = {
    'Salon Profile': Icons.person,
    'Services': Icons.shopping_basket,
    'Order History': Icons.history,
    'Dashboard': Icons.dashboard,
    'My Discount': Icons.local_offer,
    'My Combos': Icons.category,
    'My Staff': Icons.people,
    'Gallery': Icons.photo_library,
    'Plans': Icons.assignment,
    'Bank Details': Icons.account_balance,
    'Settings': Icons.settings,
    'Support': Icons.support,
    'Logout': Icons.exit_to_app
  };

  final List<String> items = [
    'Salon Profile',
    'Services',
    'Order History',
    'Dashboard',
    'My Discount',
    'My Combos',
    'My Staff',
    'Gallery',
    'Plans',
    'Bank Details',
    'Settings',
    'Support',
    'Logout'
  ];

  Color _randomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      0.1, // You can adjust the opacity here
    );
  }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  final _bottomNavigationController = Get.find<BottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _bottomNavigationController.updateSelectedIndex(0);
        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 220,
                child: Stack(
                  children: [
                    Container(
                      height: 140,
                      color: primaryColor,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          height: 170,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${vendor_data['name']}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${vendor_data['email']}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: black.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${vendor_data['mobileNumber']}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: black.withOpacity(0.4),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.white,
                          image: DecorationImage(
                            image: vendor_data['image'] == ""
                                ? NetworkImage(
                                    "https://beforeigosolutions.com/wp-content/uploads/2021/12/dummy-profile-pic-300x300-1.png")
                                : NetworkImage(
                                    IMAGE_BASE_URL + vendor_data['image'],
                                  ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Bounce(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileDetails()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 58.0, right: 25),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: Colors.blue.withOpacity(0.3),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ListView.separated(
                itemCount: items.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (context, index) {
                  String item = items[index];
                  IconData iconData = itemIcons[item]!;
                  return ListTile(
                    title: Text(item),
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: item == "Logout"
                            ? Colors.red.withOpacity(0.2)
                            : _randomColor(),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconData,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      switch (item) {
                        case 'Salon Profile':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SalonProfile(),
                            ),
                          );
                          break;
                        case 'Services':
                          // Navigate to Services screen
                          // setState(() {
                          //   curretInd = 2;
                          // });
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => MainSection(),
                          //     ),
                          //     (route) => false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuScreen(
                                        type: "profile",
                                      )));
                          break;
                        case 'Order History':

                          // Navigate to Order History screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderScreen(),
                            ),
                          );
                          break;
                        case 'Dashboard':
                          // Navigate to Dashboard screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyDashBoard(),
                            ),
                          );
                          break;
                        case 'My Discount':
                          // Navigate to My Documents screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyDiscounts(),
                            ),
                          );
                          break;
                        case 'My Combos':
                          // Navigate to My Combos screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCombos(),
                            ),
                          );
                          break;
                        case 'My Staff':
                          // Navigate to My Staff screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyStaff(
                                type: 'mainsection',
                              ),
                            ),
                          );
                          break;
                        case 'Gallery':
                          // Navigate to Gallery screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyGallery(
                                type: 'mainsection',
                              ),
                            ),
                          );
                          break;
                        case 'Plans':
                          // Navigate to Plans screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlansScreen(),
                            ),
                          );
                          break;
                        case 'Bank Details':
                          // Navigate to Bank Details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BankDetails(),
                            ),
                          );
                          break;
                        case 'Settings':
                          // Navigate to Settings screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ),
                          );
                          break;
                        case 'Support':
                          // Navigate to Settings screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupportScreen(),
                            ),
                          );
                          break;
                        case 'Logout':
                          // Navigate to Logout screen or perform logout action
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LogoutDialog();
                            },
                          );
                          break;
                        default:
                          print("No action defined for $item");
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutDialog extends StatefulWidget {
  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  final _bottomNavigationController = Get.find<BottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBoxL(context),
    ).animate().fadeIn().shimmer();
  }

  Widget contentBoxL(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/logout_2.png', // Replace with your own image asset path
                height: 170,
                width: 170,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Are you sure you want to\nlogout of your account?',
                  style: GoogleFonts.inter(
                    color: black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              //  SizedBox(
              //         height: 43,
              //       ),
              Bounce(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //     context, FadeRouteBuilder(page: MainSection()));
                },
                child: AnimatedContainer(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: sharp_green_gradeint,
                    ),
                    duration: Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Naah, Just Kidding",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 14),
              Bounce(
                onTap: () async {
                  SharedPreferences data =
                      await SharedPreferences.getInstance();
                  data.clear();
                  _bottomNavigationController.updateSelectedIndex(0);

                  // ignore: use_build_context_synchronously
                  await log_out(context);
                },
                child: AnimatedContainer(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: sharp_green_gradeint,
                    ),
                    duration: Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Align(
                        child: AnimatedContainer(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: white
                              // gradient: sharp_green_gradeint,
                              ),
                          duration: Duration(milliseconds: 200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Yes, Log me out!",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
