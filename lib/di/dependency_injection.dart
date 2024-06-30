import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rwandaliveradio_fl/pages/controllers/player_page_controller.dart';
import '../database/local_database.dart';
import '../pages/controllers/contact_us_page_controller.dart';
import '../pages/controllers/home_page_controller.dart';
import '../pages/controllers/shared/player_controller.dart';
import '../repositories/data_repository.dart';
import '../services/player_service.dart';
import '../services/theme_handler.dart';
import '../services/http_services.dart';

Future<void> registerServices() async {
  await GetStorage.init();
  Get.put(LocalDatabase());
  Get.put(ThemeHandler());
  Get.put(HttpServices());
  Get.put(DataRepository());
  Get.put(PlayerService());
  Get.put(PlayerController());
  Get.put(HomePageController(), permanent: true);
  Get.create<PlayerPageController>(() => PlayerPageController());
  Get.create<ContactUsPageController>(() => ContactUsPageController());
}
