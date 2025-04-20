import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NaverApiClient {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://openapi.naver.com/v1/search';

  static final NaverApiClient _instance = NaverApiClient._internal();

  factory NaverApiClient() {
    return _instance;
  }

  NaverApiClient._internal() {
    _dio.options.headers = {
      'X-Naver-Client-Id': dotenv.env['NAVER_CLIENT_ID'] ?? '',
      'X-Naver-Client-Secret': dotenv.env['NAVER_CLIENT_SECRET'] ?? '',
    };
  }
}
