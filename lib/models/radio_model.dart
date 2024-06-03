import 'dart:core';

class RadioModel {
  final String url;
  final String name;
  final String img;
  final int ordering;
  final String wave;
  final String description;
  final String infoSrc;
  final String shortWave;
  bool active = false;
  bool playing = false;
  bool paused = false;

  RadioModel(this.url, this.name, this.img, this.ordering, this.wave, this.shortWave,
      this.description, this.infoSrc);
}
