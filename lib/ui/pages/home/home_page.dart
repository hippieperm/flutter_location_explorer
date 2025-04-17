import 'package:flutter/material.dart';
import 'widget/list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white.withAlpha(255),
        appBar: AppBar(
          title: TextField(
            decoration: InputDecoration(
              hintText: '위치입력',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return const ListItem(
                title: '삼성1동 주민센터',
                category: '공공, 사회기관>행복복지센터',
                roadAddress: '서울특별시 강남구 봉은사로 616 삼성1동 주민센터',
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 5);
            },
            itemCount: 10,
          ),
        ),
      ),
    );
  }
}
