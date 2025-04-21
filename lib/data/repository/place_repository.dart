import '../model/place.dart';
import 'naver_api_client.dart';

class PlaceRepository {
  final NaverApiClient _naverApiClient = NaverApiClient();

  Future<PlaceResponse> searchPlacesByLocation({
    required String query,
    required double latitude,
    required double longitude,
    int radius = 5000, // 기본 반경 5km
    int display = 10,
    int start = 1,
    String sort = 'random',
  }) async {
    final locationQuery = '$query 근처';

    return await _naverApiClient.searchPlaces(
      query: locationQuery,
      display: display,
      start: start,
      sort: sort,
    );
  }

  Future<PlaceResponse> searchPlacesByKeyword({
    required String query,
    int display = 10,
    int start = 1,
    String sort = 'random',
  }) async {
    return await _naverApiClient.searchPlaces(
      query: query,
      display: display,
      start: start,
      sort: sort,
    );
  }
}
