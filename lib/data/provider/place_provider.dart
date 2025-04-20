import 'package:flutter/material.dart';
import 'package:flutter_location_explorer/data/model/place.dart';
import 'package:flutter_location_explorer/data/repository/place_repository.dart';
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
}
