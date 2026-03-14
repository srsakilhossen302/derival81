import 'package:get/get.dart';

class HomeController extends GetxController {
  var userName = "Ibrahim".obs;
  var totalSaved = 0.obs;
  var activeGroups = 0.obs;
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
