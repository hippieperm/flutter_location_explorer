import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue[700]),
      body: SafeArea(
        bottom: false,
        child: Stack(children: [_buildBackground(), _buildContent()]),
      ),
    );
  }
}

Widget _buildBackground() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue[700]!, Colors.blue[500]!, Colors.blue[300]!],
      ),
    ),
  );
}

Center _buildContent() {
  return Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 48),
            _buildTitle(),
            _buildDescription(),
          ],
        ),
      ),
    ),
  );
}

Container _buildLogo() {
  return Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(60),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Icon(Icons.place, size: 80, color: Colors.blue[700]),
  );
}

Text _buildTitle() {
  return Text(
    '위치 검색',
    style: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [
        Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
      ],
    ),
  );
}

Widget _buildDescription() {
  return const Text(
    '네이버 지역 검색 API를 이용하여\n주변의 장소를 검색해보세요!',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      height: 1.5,
      shadows: [
        Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2),
      ],
    ),
  );
}
