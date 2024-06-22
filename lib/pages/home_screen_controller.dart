import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/utils/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/radio_model.dart';
import '../models/screen_state.dart';
import '../repositories/data_repository.dart';


class HomeScreenController extends GetxController {
  //private variables
  final Rx<ScreenState> _state = (LoadingState() as ScreenState).obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isBuffering = false.obs;
  final RxBool _isError = false.obs;
  final RxBool _isStopped = true.obs;
  final RxBool _showHeaderTitle = false.obs;
  final Rx<RadioModel?> _currentRadio = (null as RadioModel?).obs;
  final RxInt _currentRadioIndex = (0).obs;
  final Rx<ItemScrollController> _homeListScrollController = (ItemScrollController()).obs;
  final Rx<ItemScrollController> _playerListScrollController = (ItemScrollController()).obs;
  late AssetsAudioPlayer _assetsAudioPlayer;
  final DataRepository _dataRepository = Get.find();
  final Rx<ItemPositionsListener> _homeItemPositionsListener = (ItemPositionsListener.create()).obs;

  //getters
  ItemScrollController get homeListScrollController  => _homeListScrollController.value;
  ItemScrollController get playerListScrollController  => _playerListScrollController.value;
  ItemPositionsListener get homeItemPositionsListener  => _homeItemPositionsListener.value;
  int get currentRadioIndex  => _currentRadioIndex.value;
  RadioModel? get currentRadio => _currentRadio.value;
  bool get showHeaderTitle => _showHeaderTitle.value;
  bool get isPlaying => _isPlaying.value;
  bool get isBuffering => _isBuffering.value;
  bool get isError => _isError.value;
  bool get isStopped => _isStopped.value;
  ScreenState get state => _state.value;



  @override
  void onInit() async {
    super.onInit();
    await _initialize();
  }

  Future<void> _initialize() async {
    _state.value = LoadingState();
    await _dataRepository.getRadios().then((value) {
      _state.value = value;
    }).catchError((error, stackTrace) {
      print("error: $error stackTrace: $stackTrace");
    }).whenComplete(() async {
      if(_state.value is LoadedState) {
        await _playerSetup();
      }
    });
  }

  @override
  void onClose() {
    _assetsAudioPlayer.dispose();
    print("_assetsAudioPlayer is disposed");
    super.onClose();
  }

  //Player setup
  Future<void> _playerSetup() async {
    _assetsAudioPlayer = AssetsAudioPlayer.withId(Constants.playerName);
    _registerObservers();
    _onError();
    await _openPlayer();
  }

  Future<void> _openPlayer() async {
    try {
    await _assetsAudioPlayer.open(
        Playlist(audios: _getAudios((_state.value as LoadedState).data), startIndex: 0),
        loopMode: LoopMode.none,
        playInBackground: PlayInBackground.enabled,
        showNotification: true,
        autoStart: false,
        notificationSettings: const NotificationSettings());
    _currentRadio.value = null;
    } catch (e) {
      _isError.value = true;
      _assetsAudioPlayer.stop();
    }
  }

  void _onError() {
    _assetsAudioPlayer.onErrorDo = (errorHandler) {
      print("handled ===> ${errorHandler.error.message}");
      _isError.value = true;
      onStop();
    };
  }

  void _registerObservers(){
    _assetsAudioPlayer.isPlaying.listen((val) {
      _isPlaying.value = val;
    });
    _assetsAudioPlayer.isBuffering.listen((val) {
      _isBuffering.value = val;
    });
    _assetsAudioPlayer.playerState.listen((val) {
      if (val == PlayerState.stop) {
        _isBuffering.value = false;
      }
    });
    homeItemPositionsListener.itemPositions.addListener((){
      final bottomVisible = homeItemPositionsListener.itemPositions.value.where((item){
        return item.itemTrailingEdge >= 0.06;
      }).map((t) => t.index).toList();
      _showHeaderTitle.value = !bottomVisible.contains(0);
    });
  }

  //End of Player setup

  //Player commands
  void onPlayRadio(int index) => _onPlayRadio(index);
  void onPlay() => _assetsAudioPlayer.playOrPause();
  void onStop() => _assetsAudioPlayer.stop();
  void onPrevious() => _onPrevious();
  void onNext() => _onNext();



  void _onPlayRadio(int index) {
    if((_currentRadioIndex.value == 0 && !isPlaying) || _currentRadioIndex.value != index){
      _currentRadioIndex.value =  index;
      final radio = (_state.value as LoadedState).data[index];
      _currentRadio.value = radio;
      _assetsAudioPlayer.playlistPlayAtIndex(index);
    }
  }
  void _onNext() {
    _currentRadioIndex.value += 1;
    _currentRadio.value = getRadioForIndex(_currentRadioIndex.value);
    _assetsAudioPlayer.next(keepLoopMode: false);
  }
  void _onPrevious(){
    _currentRadioIndex.value -= 1;
    _currentRadio.value =  getRadioForIndex(_currentRadioIndex.value);
    _assetsAudioPlayer.previous(keepLoopMode: false);
  }

  //End of Player commands

  RadioModel getRadioForIndex(int index){
    return (_state.value as LoadedState).data[index];
  }
  bool isLast() {
    return _currentRadioIndex.value + 1 == (_state.value as LoadedState).data.length;
  }

  bool isFirst() {
    return _currentRadioIndex.value == 0;
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
      album: Constants.notificationAlbumName,
      image: MetasImage.network(radio.img),
    );
  }

  RadioModel? getRadioByUrl(String url) {
    return (_state.value as LoadedState).data.firstWhereOrNull((radio) => radio.url == url);
  }

  Future<void> _refreshData() async {
    _state.value = LoadingState();
    _dataRepository.getRadios(); //FIXME revisit
  }

}
