
import 'package:get/get.dart';
import '../database/local_database.dart';
import '../models/radio_dto.dart';
import '../models/screen_state.dart';
import '../services/http_services.dart';

class DataRepository {
  final dataQuery = "allradios";
  final LocalDatabase _lDatabase = Get.find();
  final HttpServices _httpServices = Get.find();

  Future<ScreenState> getRadios() async {
    if (await _shouldFetchRemoteData()) {
      return _fetchRemoteData();
    } else {
      return _fetchLocalData();
    }
  }

  Future<bool> _shouldFetchRemoteData() async {
    try {
      final cachedTime = await _lDatabase.read(LocalDatabase.cachedTimeKey);
      final cachedData = await _lDatabase.read(LocalDatabase.cachedDataKey);
      return cachedData == null || DateTime.now().difference(DateTime.parse(cachedTime as String)).inDays > 0;
    } catch (e) {
      return true;
    }
  }

  Future<ScreenState> _fetchRemoteData() async {
    try {
      var response = await _httpServices.get(dataQuery);
      if (response.statusCode == 200) {
        final data = response.data;
        _lDatabase.saveLocalToLocalDb(data);
        return LoadedState(RadioDto.parseData(data));
      } else {
        throw ("response.statusCode not 200");
      }
    } catch (exception) {
      return ErrorState(exception.toString());
    }
  }

  Future<ScreenState> _fetchLocalData() async {
    try {
      final data = await _lDatabase.readLocal(LocalDatabase.cachedDataKey);
      return LoadedState(data);
    } catch(exception) {
      print(exception);
      _lDatabase.clearDb();
      //In case there is any issue with local data fetch data from remote source
      return _fetchRemoteData();
    }
  }

}