import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/pages/controllers/shared/player_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../models/radio_model.dart';
import '../../models/screen_state.dart';
import '../../repositories/data_repository.dart';

class HomePageController extends GetxController {
  //private variables
  final PlayerController _playerController = Get.find();
  final DataRepository _dataRepository = Get.find();
  final Rx<ScreenState> _state = (LoadingState() as ScreenState).obs;
  final Rx<ItemScrollController> _itemScrollController = (ItemScrollController()).obs;
  final Rx<ItemPositionsListener> _homeItemPositionsListener = (ItemPositionsListener.create()).obs;
  final RxBool _isSettingExpanded = false.obs;
  final RxBool _showHeaderTitle = false.obs;
  final RxInt _favoritesCount = (8).obs;


  //getters
  ItemScrollController get itemScrollController  => _itemScrollController.value;
  ItemPositionsListener get homeItemPositionsListener  => _homeItemPositionsListener.value;
  RadioModel? get currentRadio => _playerController.currentRadio;
  List<RadioModel> get playList => _playerController.playList;
  ScreenState get state => _state.value;

  bool get showHeaderTitle => _showHeaderTitle.value;
  bool get isSettingExpanded => _isSettingExpanded.value;
  bool get isPlaying => _playerController.isPlaying;
  bool get isBuffering => _playerController.isBuffering;
  int get favoritesCount => _favoritesCount.value;
  int get currentRadioIndex => _playerController.currentRadioIndex;


  @override
  void onInit() async {
    await _initialize();
    _registerScrollerListener();
    super.onInit();
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

  //Player setup
  Future<void> _playerSetup() async {
    _registerObservers();
    _playerController.onError();
    _playerController.setPlayList((_state.value as LoadedState).data);
  }

  void _registerObservers(){
    homeItemPositionsListener.itemPositions.addListener((){
      final bottomVisible = homeItemPositionsListener.itemPositions.value.where((item){
        return item.itemTrailingEdge >= 0.06;
      }).map((t) => t.index).toList();
      _showHeaderTitle.value = !bottomVisible.contains(0);
    });
  }

  Future<void> _refreshData() async {
    _state.value = LoadingState();
    _dataRepository.getRadios(); //FIXME revisit
  }

  bool isFirst() => _playerController.isFirst();
  bool isLast() => _playerController.isLast();
  bool isCurrent(int index) => _playerController.isCurrent(index);

  void onPlayRadio(int index) => _playerController.onPlayRadio(index);
  void onPlay() => _playerController.onPlay();
  void onStop() => _playerController.onStop();
  void onPrevious() => _playerController.onPrevious();
  void onNext() => _playerController.onNext();

  RadioModel getRadioForIndex(int index) => _playerController.getRadioForIndex(index);
  RadioModel? getRadioByUrl(String url)  => _playerController.getRadioByUrl(url);


  void expandedSetting(){
    _isSettingExpanded.value = !_isSettingExpanded.value;
  }
  void onEndDrawerClose(){
    _isSettingExpanded.value = false;
  }

  void _registerScrollerListener(){
    _playerController.newIndex.listen((val){
      scrollTo(val);
    });
  }

  void scrollTo(int? index) {
    if(itemScrollController.isAttached){
      itemScrollController.scrollTo(
          index: index??currentRadioIndex,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn
      );
    }
  }

}
