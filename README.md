# 🌏 위치 탐색기 (Location Explorer)

네이버 지역 검색 API를 활용하여 다양한 장소를 찾아보세요! 현재 위치 기반 검색과 키워드 검색을 지원합니다. 😊

## ✨ 주요 기능

- 🔍 키워드 기반 장소 검색
- 📍 현재 위치 기반 주변 장소 검색
- 🔄 무한 스크롤을 통한 추가 결과 로딩
- 🎨 직관적이고 아름다운 UI/UX
- 📱 반응형 디자인으로 다양한 기기 지원

## 📱 스크린샷

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/471d26fc-ed69-4c63-91d1-6c63200bfe1a" width="30%" alt="홈 화면">
  <img src="https://github.com/user-attachments/assets/4b74a8f9-f49e-4d1f-b123-fb134d915c18" width="30%" alt="검색 화면">
  <img src="https://github.com/user-attachments/assets/68d763c3-9c11-471f-a225-ea5359abbb51" width="30%" alt="상세 화면">
</div>

## 🛠️ 사용 기술

- [Flutter](https://flutter.dev/)
- [Provider](https://pub.dev/packages/provider) - 상태 관리
- [Dio](https://pub.dev/packages/dio) - HTTP 요청 처리
- [Geolocator](https://pub.dev/packages/geolocator) - 위치 서비스
- [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv) - 환경 변수 관리

## 📂 프로젝트 구조

```
lib/
├── data/                      # 데이터 계층
│   ├── model/                 # 데이터 모델
│   │   └── place.dart         # 장소 모델 클래스
│   ├── provider/              # 상태 관리 프로바이더
│   │   └── place_provider.dart
│   └── repository/            # 데이터 소스 처리
│       ├── naver_api_client.dart
│       └── place_repository.dart
├── ui/                        # UI 계층
│   ├── pages/                 # 페이지 화면
│   │   ├── home/              # 홈 페이지
│   │   │   ├── widgets/
│   │   │   └── home_page.dart
│   │   └── search/            # 검색 페이지
│   │       └── search_page.dart
│   └── widgets/               # 재사용 가능한 위젯
│       ├── loading_overlay.dart
│       ├── loading_widget.dart
│       ├── place_card_widget.dart
│       └── search_bar_widget.dart
├── util/                      # 유틸리티 함수
│   ├── location_util.dart
│   └── url_util.dart
└── main.dart                  # 앱 진입점
```

## 🚀 시작하기

1. 저장소 클론하기:

```bash
git clone https://github.com/username/flutter_location_explorer.git
cd flutter_location_explorer
```

2. 의존성 설치하기:

```bash
flutter pub get
```

3. `.env` 파일 설정하기:

```
NAVER_CLIENT_ID=your_naver_client_id
NAVER_CLIENT_SECRET=your_naver_client_secret
```

4. 앱 실행하기:

```bash
flutter run
```

## 📝 사용 방법

1. 앱을 실행하면 홈 화면이 표시됩니다.
2. "장소 검색하기" 버튼을 눌러 검색 화면으로 이동합니다.
3. 검색창에 키워드를 입력하여 장소를 검색합니다.
4. "내 위치 사용하기" 또는 검색 화면의 위치 아이콘을 통해 현재 위치 기반 검색을 사용할 수 있습니다.
5. 검색 결과 카드를 탭하여 장소 상세 정보를 확인할 수 있습니다.

## 🤝 기여하기

기여는 언제나 환영합니다! 버그 수정, 기능 추가 등 다양한 방법으로 참여해 주세요.

1. 저장소를 포크합니다.
2. 새로운 브랜치를 생성합니다: `git checkout -b feature/amazing-feature`
3. 변경사항을 커밋합니다: `git commit -m 'Add some amazing feature'`
4. 브랜치에 푸시합니다: `git push origin feature/amazing-feature`
5. Pull Request를 생성합니다.

## 📄 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 📞 문의하기

문의 사항이 있으시면 [이슈](https://github.com/username/flutter_location_explorer/issues)를 등록해 주세요.
