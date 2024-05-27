import 'package:get/get.dart';
import '../services/http_services.dart';

Future<void> registerService() async {
  Get.put(HttpServices());
}