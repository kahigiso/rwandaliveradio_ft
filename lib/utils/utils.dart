import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/ThemeHandler.dart';
import '../services/http_services.dart';

Future<void> registerServices() async {
  await GetStorage.init();
  Get.put(ThemeHandler());
  Get.put(HttpServices());
}
