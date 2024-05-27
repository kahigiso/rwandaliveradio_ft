import 'dart:core';
import 'dart:ffi';

class RadioModel {
  final String url;
  final String name;
  final String img;
  final int ordering;
  final String wave;
  final String description;
  final String infoSrc;
  bool active = false;
  bool playing = false;
  bool paused = false;

  RadioModel(this.url, this.name, this.img, this.ordering, this.wave,
      this.description, this.infoSrc);
}
