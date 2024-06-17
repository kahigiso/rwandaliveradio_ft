import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import '../models/radio_dto.dart';

class LocalDatabase {
  static String cachedDataKey = "cached_data_key";
  static String cachedTimeKey = "cached_time_key";
  final _storage = GetStorage();
  final _jsonEncoder = const JsonEncoder();
  final _jsonDecoder = const JsonDecoder();

  Future<List<RadioModel>> readLocal(String key) async {
    return RadioDto.parseData(_jsonDecoder.convert(await read(key) as String));
  }

  Future<dynamic> read(String key) async {
    return _storage.read(key);
  }

  Future<void> write(String key, dynamic value) async {
    return _storage.write(key, value);
  }

  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  Future<void> saveLocalToLocalDb(List<dynamic> data) async {
    write(cachedTimeKey, DateTime.now().toString());
    write(cachedDataKey, _jsonEncoder.convert(data));
  }

  Future<void> clearDb() async {
    delete(cachedTimeKey);
    delete(cachedDataKey);
  }
}