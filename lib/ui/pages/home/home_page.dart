import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/provider/place_provider.dart';
import '../../widgets/loading_overlay.dart';
import '../search/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue[700]),
      body: SafeArea(
        bottom: false,
        child: Stack(children: [_buildBackground(), _buildContent(context)]),
      ),
    );
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

  Center _buildContent(BuildContext context) {
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
              const SizedBox(height: 24),
              _buildDescription(),
              const SizedBox(height: 64),
              _buildSearchButton(context),
              const SizedBox(height: 16),
              _buildLocationButton(context),
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
            color: Colors.black.withAlpha(26),
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

  Widget _buildSearchButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        icon: const Icon(Icons.search),
        label: const Text('장소 검색하기'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: TextButton.icon(
        onPressed: () async {
          // 애니메이션 로딩 다이얼로그 표시
          AnimatedLoadingDialog.show(context, '위치 정보를 가져오는 중...');

          final provider = Provider.of<PlaceProvider>(context, listen: false);

          // 위치 권한 요청 및 위치 정보 가져오기
          await provider.getCurrentLocation();

          if (!context.mounted) return;

          // 로딩 다이얼로그 닫기
          AnimatedLoadingDialog.hide(context);

          if (provider.currentPosition != null) {
            // 위치 정보를 성공적으로 가져온 경우
            SuccessDialog.show(
              context,
              '위치 정보를 성공적으로 가져왔습니다!',
              onDismissed: () {
                // 다이얼로그가 닫힌 후 검색 페이지로 이동
                if (context.mounted) {
                  // 위치 기반 검색 모드 설정
                  provider.setSearchMode(true);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                }
              },
            );
          } else {
            // 위치 정보를 가져오지 못한 경우 - 에러 다이얼로그 사용
            ErrorDialog.show(
              context,
              title: '위치 정보 오류',
              message: provider.errorMessage,
            );
          }
        },
        icon: const Icon(Icons.location_on),
        label: const Text('내 위치 사용하기'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
