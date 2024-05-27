import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/services/http_services.dart';

import '../models/radio_dto.dart';
import '../models/radio_model.dart';

class HomeScreenController extends GetxController {
  RxBool  loading = false.obs;
  RxList<RadioModel> radios = <RadioModel>[].obs;
  Rx<RadioModel?> current = (null as RadioModel?).obs;

  @override
  void onInit(){
    super.onInit();
    _getRadios();
  }

  void onRadioClicked(String url){
    current.value =  getRadioByUrl(url);
  }
  
  RadioModel? getRadioByUrl(String url){
    return radios.firstWhereOrNull((radio) => radio.url == url);
  }

  Future<void> _getRadios() async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 6));
    HttpServices httpServices = Get.find();
    var response = await httpServices.get("allradios");
    if (response.statusCode == 200) {
      radios.value = response.data.map<RadioModel>((radioJson)=> RadioDto.fromJson(radioJson).toRadioModel()).toList();
    }
    //TODO check for different status and add a view event handler object
    loading.value = false;
  }

}