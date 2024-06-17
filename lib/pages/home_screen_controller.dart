import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/radio_model.dart';
import '../models/screen_state.dart';
import '../repositories/data_repository.dart';


class HomeScreenController extends GetxController {

  final Rx<ScreenState> state = (LoadingState() as ScreenState).obs;
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  final RxBool isError = false.obs;
  final RxBool isStopped = true.obs;
  final Rx<RadioModel?> currentRadio = (null as RadioModel?).obs;
  final Rx<ItemScrollController?> itemScrollController =
      (ItemScrollController()).obs;
  late AssetsAudioPlayer _assetsAudioPlayer;
  final DataRepository dataRepository = Get.find();


  @override
  void onInit() async {
    super.onInit();
    await _initialize();
  }

  @override
  void onClose() {
    _assetsAudioPlayer.dispose();
    super.onClose();
  }

  Future<void> _initialize() async {
    state.value = LoadingState();
    await dataRepository.getRadios().then((value) {
      state.value = value;
    }).catchError((error, stackTrace) {
      print("error: $error stackTrace: $stackTrace");
    }).whenComplete(() async {
      if(state.value is LoadedState) {
        await _playerSetup(); //FIXME Check for error
      }
    });
  }

  //Player setup
  Future<void> _playerSetup() async {
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    _registerObservers();
    _onError();
    await _openPlayer();
  }

  Future<void> _openPlayer() async {
    try {
    await _assetsAudioPlayer.open(
        Playlist(audios: _getAudios((state.value as LoadedState).data), startIndex: 0),
        loopMode: LoopMode.none,
        playInBackground: PlayInBackground.enabled,
        showNotification: true,
        autoStart: false,
        notificationSettings: const NotificationSettings());
    currentRadio.value = null;
    } catch (e) {
      isError.value = true;
      _assetsAudioPlayer.stop();
    }
  }

  void _onError() {
    _assetsAudioPlayer.onErrorDo = (errorHandler) {
      print("handled ===> ${errorHandler.error.message}");
      isError.value = true;
      onStop();
    };
  }

  void _registerObservers(){
    _assetsAudioPlayer.current.listen((val) {
      if(state.value is LoadedState) {
        _setCurrentRadio((state.value as LoadedState).data.firstWhere((radio) => radio.url == val?.audio.audio.path));
      }
    });
    _assetsAudioPlayer.isPlaying.listen((val) {
      isPlaying.value = val;
    });
    _assetsAudioPlayer.isBuffering.listen((val) {
      isBuffering.value = val;
    });
    _assetsAudioPlayer.playerState.listen((val) {
      if (val == PlayerState.stop) {
        isBuffering.value = false;
      }
    });
  }
  //End of Player setup

  // bool isAlreadyPlaying(RadioModel radio){
  //   return radio.url == currentRadio.value?.url;
  // }

  void _setCurrentRadio(RadioModel radio){
    currentRadio.value = radio;
  }

  //Player commands
  void onPlayRadio(RadioModel radio) {
    _setCurrentRadio(radio);
    _onPlayAtIndex((state.value as LoadedState).data.indexOf(radio));
  }

  void _onPlayAtIndex(int index) {
    _assetsAudioPlayer.playlistPlayAtIndex(index);
  }

  void onPlay() {
    _assetsAudioPlayer.playOrPause();
  }

  void onNext() {
    if(!isLast()) {
      _setCurrentRadio(_getNext());
    }
    _assetsAudioPlayer.next(keepLoopMode: false);
  }

  void onPrevious() {
    if(!isFirst()) {
      _setCurrentRadio(_getPrevious());
    }
    _assetsAudioPlayer.previous(keepLoopMode: false);
  }

  void onStop() {
    _assetsAudioPlayer.stop();
  }
  //End of Player commands

  int indexOfCurrent(){
    return (state.value as LoadedState).data.indexOf(currentRadio.value!);
  }
  bool isLast() {
    return indexOfCurrent() + 1 == (state.value as LoadedState).data.length;
  }

  bool isFirst() {
    return indexOfCurrent() == 0;
  }

  RadioModel _getNext(){
    return (state.value as LoadedState).data[indexOfCurrent() + 1];
  }

  RadioModel _getPrevious(){
     return (state.value as LoadedState).data[indexOfCurrent() - 1];
  }


  List<Audio> _getAudios(List<RadioModel> radios) {
    return radios.map<Audio>((r) => _radioModelToAudio(r)).toList();
  }

  Audio _radioModelToAudio(RadioModel radioModel) {
    return Audio.liveStream(radioModel.url, metas: _getMetas(radioModel));
  }

  Metas _getMetas(RadioModel radio) {
    return Metas(
      title: radio.name,
      artist: radio.wave,
      album: "Live Radio",
      image: MetasImage.network(radio.img),
    );
  }

  RadioModel? getRadioByUrl(String url) {
    return (state.value as LoadedState).data.firstWhereOrNull((radio) => radio.url == url);
  }
  Future<void> _refreshData() async {
    state.value = LoadingState();
    dataRepository.getRadios(); //FIXME revisit
  }

}
