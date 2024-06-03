import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/services/http_services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/radio_dto.dart';
import '../models/radio_model.dart';

class HomeScreenController extends GetxController {
  RxBool  loading = false.obs;
  RxList<RadioModel> radios = <RadioModel>[].obs;
  Rx<RadioModel?> currentPlayingRadio = (null as RadioModel?).obs;
  final Rx<ItemScrollController?> itemScrollController = (null as ItemScrollController?).obs;
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  RxBool isPlaying = false.obs;
  RxBool  isShuffling = false.obs;
  RxBool  isBuffering = false.obs;
  RxBool  isUnreachable = false.obs;


  Future<void> handError(Object error, StackTrace stackTrace) async {
    print("stackTrace======================: $error");
  }


  @override
  void onInit(){
    super.onInit();
    itemScrollController?.value = ItemScrollController();
    registerObservers();
    _getRadios();
  }
  @override
  void onClose(){
    assetsAudioPlayer.dispose();
    super.onClose();
  }

  void registerObservers(){
    assetsAudioPlayer.isPlaying.listen((val) {
      isPlaying.value = val;
    });
    assetsAudioPlayer.isShuffling.listen((val) {
      isShuffling.value  = val;
    });
    assetsAudioPlayer.isBuffering.listen((val) {
      isBuffering.value  = val;
    });
  }

  @override
  void onReady() {
    // itemScrollController?.value?.scrollTo(
    //     index: indexOfCurrentPlayingRadio(),
    //     duration: const Duration(seconds: 1),
    //     curve: Curves.fastOutSlowIn
    // );
    super.onReady();
  }

  void onRadioClicked(String url){
    currentPlayingRadio.value =  getRadioByUrl(url);
    playNewUrl(url);
  }

  Future<void> playNewUrl(String url) async {
    print("playNewUrl 1");
    try {
      print("playNewUrl 2");
      if (isPlaying.value || isPlaying.value || isPlaying.value) {
        await assetsAudioPlayer.stop();
      }
      print("playNewUrl 3 $url");
      await assetsAudioPlayer.open(
          Audio.liveStream(
            url,
            metas: getMetas(currentPlayingRadio.value!),
          ),
          loopMode: LoopMode.single,
          playInBackground: PlayInBackground.enabled,
          showNotification: true,
          notificationSettings: const NotificationSettings()
      ).timeout(const Duration(seconds: 10)); //FIXME we are timing out because failure  assetsAudioPlayer.open() is not throwing an exception
      print("playNewUrl 4");
      isUnreachable.value = false;
    } catch (e) {
      assetsAudioPlayer.stop();
      isUnreachable.value = true;
      print("playNewUrl Error: $e");
    }
  }

  void onPlayButtonClicked(){
    assetsAudioPlayer.playOrPause();
  }

  void onPrevious(){
    var currentIndex = indexOfCurrentPlayingRadio();
    if (currentIndex > 0) {
      currentPlayingRadio.value = radios[currentIndex-1];
      playNewUrl(currentPlayingRadio.value!.url);
    } else {

    }
  }

  void onNext() {
    var currentIndex = indexOfCurrentPlayingRadio();
    if (currentIndex < radios.length - 1) {
      currentPlayingRadio.value = radios[currentIndex+1];
      playNewUrl(currentPlayingRadio.value!.url);
    } else {

    }
  }

  int indexOfCurrentPlayingRadio(){
    return radios.indexOf(currentPlayingRadio.value);
  }

  bool isLast(){
    return radios.indexOf(currentPlayingRadio.value) + 1 == radios.length;
  }
  bool isFirst(){
    return radios.indexOf(currentPlayingRadio.value) == 0;
  }

  Metas getMetas(RadioModel radio){
    return Metas(
      title:  radio.name,
      artist: radio.wave,
      album: "Live Radio",
      image: MetasImage.network(radio.img), //can be MetasImage.network
    );
  }

  RadioModel? getRadioByUrl(String url){
    return radios.firstWhereOrNull((radio) => radio.url == url);
  }

  Future<void> _getRadios() async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 6));
    HttpServices httpServices = Get.find();
    var response = await httpServices.get("allradios");
    if (response.statusCode == 200) { // FIXME response can be null unhandled exception " Error: HttpException: Connection closed before full header was received, uri ="
      radios.value = response.data.map<RadioModel>((radioJson)=> RadioDto.fromJson(radioJson).toRadioModel()).toList();
    }
    //TODO check for different status and add a view event handler object
    loading.value = false;
  }

}