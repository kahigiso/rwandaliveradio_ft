import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../database/local_database.dart';
import '../repositories/data_repository.dart';
import '../services/theme_handler.dart';
import '../services/http_services.dart';

Future<void> registerServices() async {
  await GetStorage.init();
  Get.put(LocalDatabase());
  Get.put(ThemeHandler());
  Get.put(HttpServices());
  Get.put(DataRepository());
}
