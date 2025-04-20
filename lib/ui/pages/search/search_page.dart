import 'package:flutter/material.dart';
import 'package:flutter_location_explorer/data/provider/place_provider.dart';
import 'package:flutter_location_explorer/ui/widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';

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
            onPressed: () {},
            icon: Icon(Icons.location_on),
            tooltip: '현재 위치 가져오기',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            SearchBarWidget(
              onSearch: (query) {
                _performSearch(query);
              },
            ),
            _buildSearchTypeToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTypeToggle() {
    return Consumer<PlaceProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  label: '키워드 검색',
                  selected: provider.currentPosition == null,
                  onPressed: () {
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
                  selected: provider.currentPosition != null,
                  onPressed: () async {
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey[200],
        foregroundColor: selected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  void _performSearch(String query) {
    final provider = Provider.of<PlaceProvider>(context, listen: false);

    if (provider.currentPosition != null) {
      provider.searchPlacesByLocation(query);
    } else {
      provider.searchPlacesByKeyword(query);
    }
  }
}
