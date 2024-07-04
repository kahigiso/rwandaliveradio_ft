import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/pages/controllers/shared/player_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../models/radio_model.dart';

class PlayerPageController extends GetxController {
  final PlayerController _playerController = Get.find();
  final Rx<ItemScrollController> _scrollController = (ItemScrollController()).obs;

  ItemScrollController get scrollController => _scrollController.value;

  bool get isPlaying => _playerController.isPlaying;

  bool get isBuffering => _playerController.isBuffering;

  int get currentRadioIndex => _playerController.currentRadioIndex;

  RadioModel? get currentRadio => _playerController.currentRadio;

  List<RadioModel> get playList => _playerController.playList;

  bool isFirst() => _playerController.isFirst();

  bool isLast() => _playerController.isLast();

  bool isCurrent(int index) => _playerController.isCurrent(index);

  void onPlayRadio(int index) => _playerController.onPlayRadio(index);

  void onPlay() => _playerController.onPlay();

  void onStop() => _playerController.onStop();

  void onPrevious() => _playerController.onPrevious();

  void onNext() => _playerController.onNext();

  RadioModel getRadioForIndex(int index) => _playerController.getRadioForIndex(index);

  @override
  void onInit() {
    _registerScrollerListener();
    super.onInit();
  }

  void _registerScrollerListener(){
    _playerController.newIndex.listen((val){
      _scrollTo(val);
    });
  }

  void _scrollTo(int index) {
    if(scrollController.isAttached){
      scrollController.scrollTo(
          index: index,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn);
    }
  }

}
