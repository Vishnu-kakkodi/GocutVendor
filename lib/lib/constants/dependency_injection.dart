import 'package:get/get.dart';
import 'package:gocut_vendor/lib/controllers/bottomNavigation_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static void init() async {
    Get.put(BottomNavigationController());
   

  }

}
