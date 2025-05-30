import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/place.dart';
import '../repository/place_repository.dart';

enum SearchLoadingState { initial, loading, loaded, error }

class PlaceProvider extends ChangeNotifier {
  final PlaceRepository _repository = PlaceRepository();

  // 상태 변수
  SearchLoadingState _loadingState = SearchLoadingState.initial;
  String _errorMessage = '';
  List<Place> _places = [];
  Position? _currentPosition;
  String _searchQuery = '';
  int _totalItems = 0;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasMoreItems = true;
  bool _isLocationSearch = false;

  SearchLoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  List<Place> get places => _places;
  Position? get currentPosition => _currentPosition;
  String get searchQuery => _searchQuery;
  int get totalItems => _totalItems;
  int get currentPage => _currentPage;
  bool get hasMoreItems => _hasMoreItems;
  bool get isLocationSearch => _isLocationSearch;

  // 검색 결과 업데이트
  void _updateSearchResults(PlaceResponse response) {
    _places = response.items;
    _totalItems = response.total;
    _hasMoreItems = _places.length < response.total;
    _loadingState = SearchLoadingState.loaded;
  }

  // 검색 초기화
  void resetSearch() {
    _loadingState = SearchLoadingState.initial;
    _places = [];
    _searchQuery = '';
    _currentPage = 1;
    _hasMoreItems = true;
    notifyListeners();
  }

  // 현재 위치 가져오기
  Future<void> getCurrentLocation() async {
    _loadingState = SearchLoadingState.loading;
    notifyListeners();

    try {
      // 위치 서비스가 활성화되어 있는지 확인
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _loadingState = SearchLoadingState.error;
        _errorMessage = '위치 서비스가 비활성화되어 있습니다. 기기의 위치 서비스를 켜주세요.';
        notifyListeners();
        return;
      }

      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부된 경우 요청
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // 권한이 거부된 경우 처리
          _loadingState = SearchLoadingState.error;
          _errorMessage = '위치 권한이 거부되었습니다. 앱 설정에서 위치 권한을 허용해주세요.';
          notifyListeners();
          return;
        }
      }

      // 권한이 영구적으로 거부된 경우 처리
      if (permission == LocationPermission.deniedForever) {
        _loadingState = SearchLoadingState.error;
        _errorMessage = '위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 위치 권한을 허용해주세요.';
        notifyListeners();
        return;
      }

      // 위치 정보 가져오기
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // 10초 타임아웃 추가
      );

      _loadingState = SearchLoadingState.loaded;
    } catch (e) {
      _loadingState = SearchLoadingState.error;
      _errorMessage = '위치를 가져오는 데 실패했습니다: ${e.toString()}';
    }

    notifyListeners();
  }

  // 키워드 검색
  Future<void> searchPlacesByKeyword(String query) async {
    _loadingState = SearchLoadingState.loading;
    _searchQuery = query;
    _currentPage = 1;
    _places = [];
    notifyListeners();

    try {
      final response = await _repository.searchPlacesByKeyword(
        query: query,
        display: _itemsPerPage,
        start: 1,
      );

      _updateSearchResults(response);
    } catch (e) {
      _loadingState = SearchLoadingState.error;
      _errorMessage = '검색 중 오류가 발생했습니다.';
    }

    notifyListeners();
  }

  // 위치 기반 장소 검색
  Future<void> searchPlacesByLocation(String query) async {
    if (_currentPosition == null) {
      await getCurrentLocation();
      if (_currentPosition == null) {
        _loadingState = SearchLoadingState.error;
        _errorMessage = '위치 정보가 필요합니다.';
        notifyListeners();
        return;
      }
    }

    _loadingState = SearchLoadingState.loading;
    _searchQuery = query;
    _currentPage = 1;
    _places = [];
    notifyListeners();

    try {
      final response = await _repository.searchPlacesByLocation(
        query: query,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        display: _itemsPerPage,
        start: 1,
      );

      _updateSearchResults(response);
    } catch (e) {
      _loadingState = SearchLoadingState.error;
      _errorMessage = '검색 중 오류가 발생했습니다.';
    }

    notifyListeners();
  }

  // 추가 데이터 로드 (페이지네이션)
  Future<void> loadMorePlaces() async {
    if (!_hasMoreItems || _loadingState == SearchLoadingState.loading) {
      return;
    }

    _loadingState = SearchLoadingState.loading;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final start = (nextPage - 1) * _itemsPerPage + 1;

    try {
      PlaceResponse response;

      if (_currentPosition != null) {
        response = await _repository.searchPlacesByLocation(
          query: _searchQuery,
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
          display: _itemsPerPage,
          start: start,
        );
      } else {
        response = await _repository.searchPlacesByKeyword(
          query: _searchQuery,
          display: _itemsPerPage,
          start: start,
        );
      }

      if (response.items.isNotEmpty) {
        _places.addAll(response.items);
        _currentPage = nextPage;
        _hasMoreItems = _places.length < response.total;
      } else {
        _hasMoreItems = false;
      }

      _loadingState = SearchLoadingState.loaded;
    } catch (e) {
      _loadingState = SearchLoadingState.error;
      _errorMessage = '추가 데이터를 로드하는 중 오류가 발생했습니다.';
    }

    notifyListeners();
  }

  // 검색 모드 설정 메서드 추가
  void setSearchMode(bool isLocation) {
    _isLocationSearch = isLocation;
    notifyListeners();
  }
}
