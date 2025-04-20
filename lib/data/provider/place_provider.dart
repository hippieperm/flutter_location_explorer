import 'package:flutter/material.dart';
import 'package:flutter_location_explorer/data/model/place.dart';
import 'package:flutter_location_explorer/data/repository/place_repository.dart';
import 'package:flutter_location_explorer/util/location_util.dart';
import 'package:geolocator/geolocator.dart';

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
  int _itemsPerPage = 10;
  bool _hasMoreItems = true;

  SearchLoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  List<Place> get places => _places;
  Position? get currentPosition => _currentPosition;
  String get searchQuery => _searchQuery;
  int get totalItems => _totalItems;
  int get currentPage => _currentPage;
  bool get hasMoreItems => _hasMoreItems;

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

  Future<void> getCurrentLocation() async {
    _loadingState = SearchLoadingState.loading;
    notifyListeners();

    try {
      _currentPosition = await LocationUtil.getCurrentLocation();
      _loadingState = SearchLoadingState.loaded;
    } catch (e) {
      _loadingState = SearchLoadingState.error;
      _errorMessage = '위치를 가져오는 데 실패했습니다.';
    }

    notifyListeners();
  }

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
}
