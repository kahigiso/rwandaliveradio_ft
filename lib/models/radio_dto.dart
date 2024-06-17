import 'dart:core';
import 'package:rwandaliveradio_fl/models/radio_model.dart';

class RadioDto {
  final int id;
  final String url;
  final String name;
  final String img;
  final int order;
  final String wave;
  final String desc;
  final String infoSrc;
  final bool active;

  RadioDto(this.id, this.url, this.name, this.img, this.order, this.wave,
      this.desc, this.infoSrc, this.active);

  RadioDto.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        url = json['url'] as String,
        img = json['img'] as String,
        wave = json['wave'] as String,
        order = json['order'] as int,
        infoSrc = json['infoSrc'] as String,
        desc = json['desc'] as String,
        active = json['active'] as bool;

  Map<String, dynamic> toJson() => {  //probably not needed.
        'id': id,
        'name': name,
        'url': url,
        'img': img,
        'wave': wave,
        'order': order,
        'infoSrc': infoSrc,
        'desc': desc,
        'active': active,
      };

  RadioModel toRadioModel() {
    final shortWave = getShortWave().trim();
    return RadioModel(url, name, img.trim(), order, wave, shortWave, desc, infoSrc);
  }

  static List<RadioModel> parseData(dynamic data) {
    return data
        .map<RadioModel>(
            (radioJson) => RadioDto.fromJson(radioJson).toRadioModel())
        .toList();
  }

  String getShortWave() {
    if(wave.isEmpty) {
      return "Internet Radio";
    } else{
      if(wave.contains(",")) {
        return wave.split(",")[1];
      } else if(wave.contains("Kigali")){
        return wave.replaceAll("Kigali","");
      }else {
        return wave;
      }
    }
  }
}
