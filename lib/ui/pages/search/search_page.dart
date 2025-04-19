import 'package:flutter/material.dart';

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
      body: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '검색어를 입력하세요',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {}
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
