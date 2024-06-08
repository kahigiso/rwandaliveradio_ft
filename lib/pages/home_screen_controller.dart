import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/services/http_services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/radio_dto.dart';
import '../models/radio_model.dart';

enum DisplayStatus {
  playing("Playing", "Now playing"),
  buffering("Buffering", "Buffering ..."),
  stop("Stop", "Stopped"),
  error("Error", "Error occurred try again!");

  const DisplayStatus(this.value, this.msg);

  final String value;
  final String msg;
}

enum DisplayStatusIndicator { red, green, yellow }

class HomeScreenController extends GetxController {
  RxBool loading = false.obs;
  RxBool isDark = false.obs;
  RxList<RadioModel> radios = <RadioModel>[].obs;
  Rx<RadioModel?> currentPlayingRadio = (null as RadioModel?).obs;
  final Rx<ItemScrollController?> itemScrollController =
      (ItemScrollController()).obs;
  AssetsAudioPlayer? assetsAudioPlayer = null;
  RxBool isPlaying = false.obs;
  RxBool isStopped = false.obs;
  RxBool isBuffering = false.obs;
  RxBool isError = false.obs;
  Rx<DisplayStatus> displayStatus = (DisplayStatus.buffering).obs;
  Rx<DisplayStatusIndicator> displayStatusIndicator =
      (DisplayStatusIndicator.yellow).obs;

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
    _getRadios();
  }

  void initializePlayer(){
    if(assetsAudioPlayer != null) assetsAudioPlayer?.dispose();
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    onError();
    registerObservers();
  }

  //Callback in case of player error
  void onError() {
    assetsAudioPlayer?.onErrorDo = (errorHandler) {
      print("handled ===> ${errorHandler.error.message}");
      errorHandler.player.stop();
      isError.value = true;
      updateDisplayStatus();
    };
  }

  @override
  void onClose() {
    assetsAudioPlayer?.dispose();
    super.onClose();
  }

  void registerObservers() {
    assetsAudioPlayer?.playerState.listen((val) {
      print("======= playerState $val");
    });
    assetsAudioPlayer?.isPlaying.listen((val) {
      isPlaying.value = val;
      updateDisplayStatus();
    });
    assetsAudioPlayer?.isBuffering.listen((val) {
      isBuffering.value = val;
      updateDisplayStatus();
    });
    assetsAudioPlayer?.playerState.listen((val){
      print("======= *playerState $val");
      if(val == PlayerState.stop){
        isStopped.value = true;
        updateDisplayStatus();
      }
    });

  }

  void updateDisplayStatus() {
    if (isPlaying.value) {
      displayStatus.value = DisplayStatus.playing;
      displayStatusIndicator.value = DisplayStatusIndicator.green;
    } else if (isBuffering.value && !isError.value) {
      displayStatus.value = DisplayStatus.buffering;
      displayStatusIndicator.value = DisplayStatusIndicator.yellow;
    } else if (isStopped.value && !isError.value) {
      displayStatus.value = DisplayStatus.stop;
      displayStatusIndicator.value = DisplayStatusIndicator.red;
    } else {
      isBuffering.value = false;
      displayStatus.value = DisplayStatus.error;
      displayStatusIndicator.value = DisplayStatusIndicator.red;
    }
  }

  void changeTheme(bool value) {
    isDark.value = value;
  }

  void onRadioClicked(String url) {
    currentPlayingRadio.value = getRadioByUrl(url);
    playNewUrl(url);
  }

  Future<void> playNewUrl(String url) async {
    print(" KKKk========= isPlaying.value ${isPlaying.value} isBuffering.value ${isBuffering.value} isStopped.value ${isStopped.value} isError.value ${isError.value}");
    try {
      if (isPlaying.value || isBuffering.value) {
        await assetsAudioPlayer?.stop();
      }
      await assetsAudioPlayer?.open(
          Audio.liveStream(
            url,
            metas: getMetas(currentPlayingRadio.value!),
          ),
          loopMode: LoopMode.single,
          playInBackground: PlayInBackground.enabled,
          showNotification: true,
          notificationSettings:
              const NotificationSettings()); //FIXME we are timing out because failure  assetsAudioPlayer.open() is not throwing an exception
    } catch (e) {
      assetsAudioPlayer?.stop();
    }
  }

  void onPlayButtonClicked() {
    print(" ****========= isPlaying.value ${isPlaying.value} isBuffering.value ${isBuffering.value} isStopped.value ${isStopped.value} isError.value ${isError.value} ===== ++");
    if(isError.value) {
      initializePlayer();
      playNewUrl(currentPlayingRadio.value!.url);
    }else {
      assetsAudioPlayer?.playOrPause();
    }
  }

  void onPrevious() {
    if(isError.value) {
      initializePlayer();
    }
    var currentIndex = indexOfCurrentPlayingRadio();
    if (currentIndex > 0) {
      currentPlayingRadio.value = radios[currentIndex - 1];
      playNewUrl(currentPlayingRadio.value!.url);
    } else {}
  }

  void onNext() {
    if(isError.value) {
      initializePlayer();
    }
    var currentIndex = indexOfCurrentPlayingRadio();
    if (currentIndex < radios.length - 1) {
      currentPlayingRadio.value = radios[currentIndex + 1];
      playNewUrl(currentPlayingRadio.value!.url);
    } else {}
  }

  int indexOfCurrentPlayingRadio() {
    return radios.indexOf(currentPlayingRadio.value);
  }

  bool isLast() {
    return radios.indexOf(currentPlayingRadio.value) + 1 == radios.length;
  }

  bool isFirst() {
    return radios.indexOf(currentPlayingRadio.value) == 0;
  }

  Metas getMetas(RadioModel radio) {
    return Metas(
      title: radio.name,
      artist: radio.wave,
      album: "Live Radio",
      image: MetasImage.network(radio.img), //can be MetasImage.network
    );
  }

  RadioModel? getRadioByUrl(String url) {
    return radios.firstWhereOrNull((radio) => radio.url == url);
  }

  Future<void> _getRadios() async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 6));
    HttpServices httpServices = Get.find();
    var response = await httpServices.get("allradios");
    if (response.statusCode == 200) {
      // FIXME response can be null unhandled exception " Error: HttpException: Connection closed before full header was received, uri ="
      radios.value = response.data
          .map<RadioModel>(
              (radioJson) => RadioDto.fromJson(radioJson).toRadioModel())
          .toList();
    }
    //TODO check for different status and add a view event handler object
    loading.value = false;
  }
}
