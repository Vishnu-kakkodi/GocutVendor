import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  // Observable variable for selected index
  var selectedIndex = (0).obs;

  // Method to update the selected index
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  // Check if an index is selected
  bool isSelected(int index) {
    return selectedIndex.value == index;
  }
}
