import 'package:flutter/material.dart';
import 'package:flutter_location_explorer/ui/widgets/search_bar_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
                print(query);
              },
            ),
          ],
        ),
      ),
    );
  }
}
