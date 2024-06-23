
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/utils/constants.dart';
import '../database/local_database.dart';
import '../models/radio_dto.dart';
import '../models/screen_state.dart';
import '../services/http_services.dart';
import 'package:logging/logging.dart';


class DataRepository {
  final log = Logger('DataRepository');
  final LocalDatabase _lDatabase = Get.find();
  final HttpServices _httpServices = Get.find();

  Future<ScreenState> getRadios() async {
    await Future<void>.delayed(const Duration(seconds: 10));
    if (await _shouldFetchRemoteData()) {
      return _fetchRemoteData();
    } else {
      return _fetchLocalData();
    }
  }

  Future<bool> _shouldFetchRemoteData() async {
    try {
      final cachedTime = await _lDatabase.read(Constants.cachedTimeKey);
      final cachedData = await _lDatabase.read(Constants.cachedDataKey);
      return cachedData == null || DateTime.now().difference(DateTime.parse(cachedTime as String)).inDays > 0;
    } catch (exception) {
      log.info(exception);
      return true;
    }
  }

  Future<ScreenState> _fetchRemoteData() async {
    try {
      var response = await _httpServices.get(Constants.dataQuery);
      if (response.statusCode == 200) {
        final data = response.data;
        _lDatabase.saveLocalToLocalDb(data);
        return LoadedState(RadioDto.parseData(data));
      } else {
        throw ("Fetching remote data failed with statusCode: ${response.statusCode}");
      }
    } catch (exception) {
      log.severe(exception);
      return ErrorState(exception.toString());
    }
  }

  Future<ScreenState> _fetchLocalData() async {
    try {
      final data = await _lDatabase.readLocal(Constants.cachedDataKey);
      return LoadedState(data);
    } catch(exception) {
      log.info(exception.toString());
      _lDatabase.clearDb();
      //In case there is any issue with local data fetch data from remote source
      return _fetchRemoteData();
    }
  }

}