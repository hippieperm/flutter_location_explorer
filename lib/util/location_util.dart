import 'package:geolocator/geolocator.dart';

class LocationUtil {
  // 위치 권한 확인 및 요청
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화된 경우 처리
      return false;
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 권한이 거부된 경우 요청
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부된 경우 처리
        return false;
      }
    }

    // 권한이 영구적으로 거부된 경우 처리
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // 현재 위치 가져오기
  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await requestLocationPermission();

    if (!hasPermission) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }
}
