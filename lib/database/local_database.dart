import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import '../models/radio_dto.dart';
import '../utils/constants.dart';

class LocalDatabase {
  final log = Logger('LocalDatabase');
  final _storage = GetStorage();
  final _jsonEncoder = const JsonEncoder();
  final _jsonDecoder = const JsonDecoder();

  Future<List<RadioModel>> readLocal(String key) async {
    return RadioDto.parseData(_jsonDecoder.convert(await read(key) as String));
  }

  dynamic read(String key) {
    return _storage.read(key);
  }

  Future<void> write(String key, dynamic value) async {
    return _storage.write(key, value);
  }

  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  Future<void> saveLocalToLocalDb(List<dynamic> data) async {
    write(Constants.cachedTimeKey, DateTime.now().toString());
    write(Constants.cachedDataKey, _jsonEncoder.convert(data));
    log.info("Local db successfully updated");
  }

  Future<void> clearDb() async {
    delete(Constants.cachedTimeKey);
    delete(Constants.cachedDataKey);
    log.info("Local db successfully cleared");
  }
}