import 'package:url_launcher/url_launcher.dart';
import '../data/model/place.dart';

class UrlUtil {
  // URL 열기
  static Future<bool> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  // 전화 걸기
  static Future<bool> callPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }

    return false;
  }

  // 지도 열기 - 수정된 버전
  static Future<bool> openMap(double mapx, double mapy, String title) async {
    // HTML 태그 제거
    final cleanTitle = title.replaceAll('<b>', '').replaceAll('</b>', '');

    // 네이버 지도는 epsg:5179 좌표를 사용하므로,
    // 직접 네이버 검색 결과 페이지로 이동하는 방식으로 변경
    final encodedTitle = Uri.encodeComponent(cleanTitle);
    final url =
        'https://m.map.naver.com/search2/search.naver?query=$encodedTitle';

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }

  // Place 객체를 사용하여 지도 열기 (더 나은 방식)
  static Future<bool> openMapWithPlace(Place place) async {
    final encodedTitle = Uri.encodeComponent(place.cleanTitle);
    final url =
        'https://m.map.naver.com/search2/search.naver?query=$encodedTitle';

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }
}
