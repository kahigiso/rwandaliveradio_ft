import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import '../../../models/radio_model.dart';
import '../../../services/player_service.dart';

class PlayerController extends GetxController {
  late IPlayerService playerService = Get.find<PlayerService>();

  final RxBool _isPlaying = false.obs;
  final RxBool _isBuffering = false.obs;
  final RxBool _isError = false.obs;
  final RxBool _isStopped = true.obs;
  final Rx<RadioModel?> _currentRadio = (null as RadioModel?).obs;
  final RxInt _currentRadioIndex = (0).obs;
  final RxList<RadioModel> _playList = <RadioModel>[].obs;

  //public variable
  bool get isPlaying => _isPlaying.value;

  bool get isBuffering => _isBuffering.value;

  bool get isError => _isError.value;

  bool get isStopped => _isStopped.value;

  int get currentRadioIndex => _currentRadioIndex.value;

  RadioModel? get currentRadio => _currentRadio.value;

  List<RadioModel> get playList => _playList;
  
  @override
  void onInit(){
    _registerPlayerObservers();
    super.onInit();
  }
  @override
  void onClose(){
    playerService.dispose();
    super.onClose();
  }


  //Player commands and public functions
  Future<void> openPlayer(List<RadioModel> radios) async {
    try {
      setPlayList(radios);
      await playerService.open(radios);
      _currentRadio.value = null;
    } catch (e) {
      _isError.value = true;
      playerService.getPlayer().stop();
    }
  }
  void onPlayRadio(int index) => _onPlayRadio(index);

  void onPlay() => playerService.onPlay();

  void onStop() => playerService.onStop();

  void onPrevious() => _onPrevious();

  void onNext() => _onNext();

  void onError() => _onError();

  RadioModel getRadioForIndex(int index) {
    return playList[index];
  }

  bool isLast() {
    return _currentRadioIndex.value + 1 == _playList.length;
  }

  bool isFirst() {
    return _currentRadioIndex.value == 0;
  }

  bool isCurrent(int index) {
    return index == currentRadioIndex && currentRadio != null;
  }

  void setPlayList(List<RadioModel> radios){
    _playList.value = radios;
  }

  RadioModel? getRadioByUrl(String url) {
    return _playList.firstWhereOrNull((radio) => radio.url == url);
  }
  //Private functions
  Future<void> _onPlayRadio(int index) async {
    if ((_currentRadioIndex.value == 0 && !isPlaying) ||
        _currentRadioIndex.value != index) {
      _currentRadioIndex.value = index;
      final radio = playList[index];
      _currentRadio.value = radio;
      await playerService.onPlayRadio(index);
    }
  }

  void _registerPlayerObservers(){
    playerService.getPlayer().isPlaying.listen((val) {
      _isPlaying.value = val;
    });
    playerService.getPlayer().isBuffering.listen((val) {
      _isBuffering.value = val;
    });
    playerService.getPlayer().playerState.listen((val) {
      if (val == PlayerState.stop) {
        _isBuffering.value = false;
      }
    });
  }

  void _onNext() async {
    _currentRadioIndex.value += 1;
    _currentRadio.value = getRadioForIndex(_currentRadioIndex.value);
    await playerService.onNext();
  }

  void _onPrevious() async {
    _currentRadioIndex.value -= 1;
    _currentRadio.value = getRadioForIndex(_currentRadioIndex.value);
    await playerService.onPrevious();
  }

  void _onError() {
    playerService.onError(() {
      _isError.value = true;
      onStop();
    });
  }
}
