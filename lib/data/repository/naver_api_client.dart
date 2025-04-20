import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_location_explorer/data/model/place.dart';

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
  Future<PlaceResponse> searchPlaces({
    required String query,
    int display = 10,
    int start = 1,
    String sort = 'random', // random, comment
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/local.json',
        queryParameters: {
          'query': query,
          'display': display,
          'start': start,
          'sort': sort,
        },
      );
      return PlaceResponse.fromJson(response.data);
    } catch (e) {
      return PlaceResponse(total: 0, start: 0, display: 0, items: []);
    }
  }
}
