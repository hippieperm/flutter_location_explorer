import 'package:flutter/material.dart';
import '../../../data/provider/place_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/place_card_widget.dart';
import '../../widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';
import '../../widgets/loading_overlay.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<PlaceProvider>(context, listen: false);
      if (provider.loadingState != SearchLoadingState.loading &&
          provider.hasMoreItems) {
        provider.loadMorePlaces();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장소 검색'),
        actions: [
          IconButton(
            onPressed: () async {
              // 애니메이션 로딩 다이얼로그 표시
              AnimatedLoadingDialog.show(context, '위치 정보를 가져오는 중...');

              final provider = Provider.of<PlaceProvider>(
                context,
                listen: false,
              );
              await provider.getCurrentLocation();

              if (!context.mounted) return;

              // 로딩 다이얼로그 닫기
              AnimatedLoadingDialog.hide(context);

              if (provider.currentPosition != null) {
                // 위치 정보 가져오기 성공
                SuccessDialog.show(
                  context,
                  '위치 정보를 성공적으로 가져왔습니다!',
                  onDismissed: () {
                    if (context.mounted) {
                      // 위치 기반 검색 모드로 설정
                      provider.setSearchMode(true);

                      // 검색어가 있으면 위치 기반 검색 실행
                      if (provider.searchQuery.isNotEmpty) {
                        provider.searchPlacesByLocation(provider.searchQuery);
                      }
                    }
                  },
                );
              } else {
                // 위치 정보 가져오기 실패 - 에러 다이얼로그 사용
                ErrorDialog.show(
                  context,
                  title: '위치 정보 오류',
                  message: provider.errorMessage,
                );
              }
            },
            icon: Icon(Icons.location_on),
            tooltip: '현재 위치 가져오기',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              SearchBarWidget(
                onSearch: (query) {
                  _performSearch(query);
                },
              ),
              _buildSearchTypeToggle(),
              Expanded(child: _buildSearchResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<PlaceProvider>(
      builder: (context, provider, child) {
        final loadingState = provider.loadingState;

        if (loadingState == SearchLoadingState.initial) {
          return const Center(child: Text('검색어를 입력하세요'));
        }

        if (loadingState == SearchLoadingState.loading &&
            provider.places.isEmpty) {
          return const LoadingWidget(message: '검색 중...');
        }

        if (loadingState == SearchLoadingState.error &&
            provider.places.isEmpty) {
          return ErrorDisplayWidget(
            message: provider.errorMessage,
            onRetry: () {
              if (provider.searchQuery.isNotEmpty) {
                _performSearch(provider.searchQuery);
              }
            },
          );
        }

        if (provider.places.isEmpty) {
          return const Center(child: Text('검색 결과가 없습니다'));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: provider.places.length + (provider.hasMoreItems ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < provider.places.length) {
              return PlaceCardWidget(place: provider.places[index]);
            } else {
              // 로딩 상태에 따라 로딩 인디케이터 또는 '더 불러오기' 버튼 표시
              return loadingState == SearchLoadingState.loading
                  ? const LoadingMoreWidget()
                  : _buildLoadMoreButton(provider);
            }
          },
        );
      },
    );
  }

  Widget _buildSearchTypeToggle() {
    return Consumer<PlaceProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  label: '키워드 검색',
                  selected: !provider.isLocationSearch,
                  onPressed: () {
                    provider.setSearchMode(false);
                    if (provider.searchQuery.isNotEmpty) {
                      provider.searchPlacesByKeyword(provider.searchQuery);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildToggleButton(
                  label: '내 주변 검색',
                  selected: provider.isLocationSearch,
                  onPressed: () async {
                    provider.setSearchMode(true);

                    if (provider.currentPosition == null) {
                      await provider.getCurrentLocation();
                    }

                    if (provider.searchQuery.isNotEmpty &&
                        provider.currentPosition != null) {
                      provider.searchPlacesByLocation(provider.searchQuery);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 55,

      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.grey[200],
          foregroundColor: selected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildLoadMoreButton(PlaceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => provider.loadMorePlaces(),
        child: const Text('더 불러오기'),
      ),
    );
  }

  void _performSearch(String query) {
    final provider = Provider.of<PlaceProvider>(context, listen: false);

    if (provider.isLocationSearch && provider.currentPosition != null) {
      provider.searchPlacesByLocation(query);
    } else {
      provider.searchPlacesByKeyword(query);
    }
  }
}
