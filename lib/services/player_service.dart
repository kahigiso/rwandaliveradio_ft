import 'package:assets_audio_player/assets_audio_player.dart';
import '../models/radio_model.dart';
import '../utils/constants.dart';

class PlayerService implements IPlayerService {
  final  _assetsAudioPlayer = AssetsAudioPlayer.withId(Constants.playerName);

  @override
  AssetsAudioPlayer getPlayer() {
    return _assetsAudioPlayer;
  }

  @override
  Future<void> open(List<RadioModel> radios) async {
    await _assetsAudioPlayer.open(
        Playlist(audios: _getAudios(radios), startIndex: 0),
        loopMode: LoopMode.none,
        playInBackground: PlayInBackground.enabled,
        showNotification: true,
        autoStart: false,
        notificationSettings: const NotificationSettings()
    );
  }

  @override
  Future<void> onPlayRadio(int index) async => await _assetsAudioPlayer.playlistPlayAtIndex(index);

  @override
  Future<void> onPlay() async => await _assetsAudioPlayer.playOrPause();

  @override
  Future<void> onStop() async  => await _assetsAudioPlayer.stop();

  @override
  Future<void> onPrevious() async  => await _assetsAudioPlayer.previous(keepLoopMode: true);

  @override
  Future<void> onNext() async => await _assetsAudioPlayer.next(keepLoopMode: true);

  @override
  void onError(Function onError) {
    _assetsAudioPlayer.onErrorDo = (errorHandler) {
      print("handled ===> ${errorHandler.error.message}");
      onError();
    };
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
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


}

abstract class IPlayerService {
  AssetsAudioPlayer getPlayer();
  Future<void> onPlayRadio(int index);
  Future<void> onPlay();
  Future<void> onStop();
  Future<void> onPrevious();
  Future<void> onNext();
  Future<void> open(List<RadioModel> radios);
  void onError(Function onError) ;
  void dispose();
}