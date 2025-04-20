import 'package:url_launcher/url_launcher.dart';

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

  // 지도 열기
  static Future<bool> openMap(
    double latitude,
    double longitude,
    String title,
  ) async {
    final url =
        'https://map.naver.com/p/directions/-/$title,,/$latitude,$longitude,PLACE_POI/-/transit';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return false;
  }
}
