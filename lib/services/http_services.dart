import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class HttpServices {
  final log = Logger('LocalDatabase');
  final baseUrl = "http://50.116.28.7:9000/";
  final Dio _dio = Dio();

  HttpServices() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(baseUrl: baseUrl, queryParameters: {
      /**No query?*/
    });
  }

  Future<dynamic> get(String path) async {
    try {
      return await _dio.get(path);
    } catch (exception) {
      log.severe(exception);
      rethrow;
    }
  }
}
