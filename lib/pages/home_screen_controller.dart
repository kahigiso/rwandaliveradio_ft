import 'dart:async';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rwandaliveradio_fl/services/http_services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/radio_dto.dart';
import '../models/radio_model.dart';
import '../models/screen_state.dart';


class HomeScreenController extends GetxController {

  final Rx<ScreenState> state = (LoadingState() as ScreenState).obs;
  final RxBool dataFetchingFailed = false.obs;
  final RxBool isDark = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  final RxBool isError = false.obs;
  final RxBool isStopped = true.obs;
  final Rx<RadioModel?> currentRadio = (null as RadioModel?).obs;
  final Rx<ItemScrollController?> itemScrollController =
      (ItemScrollController()).obs;
  late AssetsAudioPlayer _assetsAudioPlayer;
  final _storage = GetStorage();
  final _data = "data";
  final _jsonEncoder = const JsonEncoder();
  final _jsonDecoder = const JsonDecoder();
  final _cachedTime = "cached_time";


  @override
  void onInit() async {
    super.onInit();
    await _getRadios().whenComplete(() async {
      await initializePlayer(); //FIXME Check for error
    });
  }

  @override
  void onClose() {
    _assetsAudioPlayer.dispose();
    super.onClose();
  }

  void changeTheme(bool value) {
    isDark.value = value;
  }

  //PLayer setup
  Future<void> initializePlayer() async {
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    registerObservers();
    onError();
    await openPlayer();
  }

  Future<void> openPlayer() async {
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

  void onError() {
    _assetsAudioPlayer.onErrorDo = (errorHandler) {
      print("handled ===> ${errorHandler.error.message}");
      isError.value = true;

      onStop();
    };
  }

  void registerObservers(){
    _assetsAudioPlayer.current.listen((val) {
      _setCurrentRadio((state.value as LoadedState).data.firstWhere((radio) => radio.url == val?.audio.audio.path));
    });
    _assetsAudioPlayer.isPlaying.listen((val) {
      isPlaying.value = val;
    });
    _assetsAudioPlayer.isBuffering.listen((val) {
      isBuffering.value = val;
    });
    _assetsAudioPlayer.playerState.listen((val) {
      print("playerState changed: $val");
      if (val == PlayerState.stop) {
        isBuffering.value = false;
      }
    });
  }
  //End of Player setup

  bool isAlreadyPlaying(RadioModel radio){
    return radio.url == currentRadio.value?.url;
  }
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
    await _storage.remove(_data);
    await _storage.remove(_cachedTime);
    _getRadios();
  }
  Future<void> _getRadios() async {
    state.value = LoadingState();
    if (_shouldFetchRemoteData()) {
      _fetRemoteData();
    } else {
      final data = _storage.read(_data);
      if( data != null) {
        state.value = LoadedState(_parseData(_jsonDecoder.convert(data)));
      } else { //Edge case
        _fetRemoteData();
      }
    }
  }

  List<RadioModel> _parseData(dynamic data) {
    return data
        .map<RadioModel>(
            (radioJson) => RadioDto.fromJson(radioJson).toRadioModel())
        .toList();
  }

  Future<void> _fetRemoteData() async {
    try {
      HttpServices httpServices = Get.find();
      var response = await httpServices.get("allradios");
      if (response.statusCode == 200) {
        final data = response.data;
        state.value = LoadedState(_parseData(data));
        _storage.write(_cachedTime, DateTime.now().toString());
        _storage.write(_data, _jsonEncoder.convert(data));
      } else {
        throw ("response.statusCode not 200");
      }
    } catch (exception) {
      print(exception);
      state.value = ErrorState(exception.toString());
    }
  }

  /// Check if we need to fetch remote data
  bool _shouldFetchRemoteData() {
    try {
      final cachedTime = _storage.read(_cachedTime);
      return _storage.read(_data) == null ||
          DateTime.now().difference(DateTime.parse(cachedTime)).inDays > 0;
    } catch (e) {
      return true;
    }
  }
}
