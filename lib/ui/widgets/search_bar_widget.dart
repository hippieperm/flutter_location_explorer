import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
    );
  }
}
