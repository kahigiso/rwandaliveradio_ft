import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpServices {
  final Dio _dio = Dio();
  
  HttpServices(){
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: "http://50.116.28.7:9000/",
      queryParameters: {
        //No query?
      }
    );
  }

  Future<dynamic> get(String path) async {
    try{
      return  await _dio.get(path);
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  
}